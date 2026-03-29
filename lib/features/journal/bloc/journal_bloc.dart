import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/core/services/ai_service.dart';
import 'package:journal/core/services/local_storage_service.dart';
import 'package:journal/core/services/network_service.dart';
import 'package:journal/core/services/telegram_service.dart';
import 'package:journal/core/utils/formatters.dart';
import 'package:journal/data/models/journal_entry.dart';
import 'package:journal/features/journal/bloc/journal_event.dart';
import 'package:journal/features/journal/bloc/journal_state.dart';
import 'package:journal/features/journal/repo/journal_repo.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final AIService ai;
  final TelegramService telegram;
  final JournalRepo repo;
  final NetworkService networkService;
  final LocalStorageService localStorageService;

  JournalBloc(
    this.ai,
    this.telegram,
    this.repo,
    this.networkService,
    this.localStorageService,
  ) : super(JournalInital()) {
    on<CreateJournal>((CreateJournal event, Emitter<JournalState> emit) async {
      emit(JournalLoading());
      final journal = JournalEntity(
        title: event.title,
        content: event.content,
        createdAt: DateTime.now(),
      );

      await repo.save(journal);
      emit(JournalCreated());
      if (await networkService.isOnline() && localStorageService.isAutoPost) {
        try {
          emit(SummarizingJournal());
          final result = await ai.process(event.content);

          journal.summary = result.summary;
          journal.tags = result.tags.map((tag) => tag.toString()).toList();
          journal.mood = result.mood;

          await repo.update(journal);

          final message = formatTelegramPost(journal);
          emit(PostingSummarizedJournal());
          await telegram.sendMessage(message);

          journal.isPosted = true;
          repo.update(journal);
          emit(SummarizedJournalPosted(journal));
        } catch (e) {
          emit(JournalError());
        }
      }
    });

    on<SummarizeAndPost>((
      SummarizeAndPost event,
      Emitter<JournalState> emit,
    ) async {
      emit(SummarizingJournal());
      if (!await networkService.isOnline()) {
        emit(SummarizingError(message: "youre offline"));
        return;
      }
      try {
        JournalEntity? journal = await repo.getJournal(event.journal.id);
        if (journal == null) {
          emit(SummarizingError(message: "Journal Not found"));
          return;
        }

        final result = await ai.process(event.journal.content);
        journal.summary = result.summary;
        journal.tags = result.tags.map((tag) => tag.toString()).toList();
        journal.mood = result.mood;

        await repo.update(journal);

        final message = formatTelegramPost(journal);
        emit(PostingSummarizedJournal());
        await telegram.sendMessage(message);

        journal.isPosted = true;
        repo.update(journal);
        emit(SummarizedJournalPosted(journal));
      } catch (e) {
        emit(SummarizingError());
      }
    });

    on<GetJournals>((GetJournals event, Emitter<JournalState> emit) async {
      emit(JournalLoading());
      try {
        List<JournalEntity> journals = repo.getAll();
        emit(JournalsLoaded(journals));
      } catch (e) {
        emit(JournalError());
      }
    });
    on<RemoveJournal>((RemoveJournal event, Emitter<JournalState> emit) async {
      emit(JournalLoading());
      try {
        repo.removeJournal(event.journal.id);
        emit(JournalRemoved());
      } catch (e) {
        emit(JournalError());
      }
    });
    on<UpdateJournal>((UpdateJournal event, Emitter<JournalState> emit) async {
      emit(JournalLoading());
      try {
        await repo.update(event.journal);
        emit(JournalUpdated());
      } catch (e) {
        emit(JournalError());
      }
    });
  }
}
