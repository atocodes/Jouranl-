import 'package:journal/data/models/journal_entry.dart';

abstract class JournalState {}

class JournalInital extends JournalState {}

class JournalLoading extends JournalState {}

class JournalSuccess extends JournalState {}

class JournalsLoaded extends JournalState {
  List<JournalEntity> journals;
  JournalsLoaded(this.journals);
}

class JournalCreated extends JournalState {}

class SummarizingJournal extends JournalState {}

class PostingSummarizedJournal extends JournalState {}

class SummarizedJournalPosted extends JournalState {
  JournalEntity journal;
  SummarizedJournalPosted(this.journal);
}

class SummarizingError extends JournalError {
  String? message;
  SummarizingError({this.message});
}

class JournalRemoved extends JournalState {}

class JournalUpdated extends JournalState {}

class JournalError extends JournalState {
  String? message;
  JournalError({this.message});
}
