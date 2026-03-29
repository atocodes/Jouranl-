import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/core/services/ai_service.dart';
import 'package:journal/core/services/local_storage_service.dart';
import 'package:journal/core/services/network_service.dart';
import 'package:journal/core/services/secure_storage_service.dart';
import 'package:journal/core/services/telegram_service.dart';
import 'package:journal/features/onboarding/bloc/onboarding_event.dart';
import 'package:journal/features/onboarding/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final TelegramService telegram;
  final LocalStorageService localStorage;
  final SecureStorageService storage;
  final AIService aiService;
  final NetworkService networkService;

  OnboardingBloc(
    this.telegram,
    this.storage,
    this.localStorage,
    this.aiService,
    this.networkService,
  ) : super(OnboardingInitial()) {
    on<GetTokens>((GetTokens event, Emitter<OnboardingState> emit) async {
      emit(OnboardingLoading());
      try {
        emit(
          TokensLoaded(
            await storage.getChatId(),
            await storage.getTelegramBotToken(),
            await storage.getOllamaToken(),
          ),
        );
      } catch (e) {
        emit(OnboardingError(e.toString()));
      }
    });
    on<SubmitTelegramSetup>((
      SubmitTelegramSetup event,
      Emitter<OnboardingState> emit,
    ) async {
      emit(OnboardingLoading());
      if (!await networkService.isOnline()) {
        emit(OnboardingError("Youre Currently Offline"));
        return;
      }
      try {
        if (event.integrationType == IntegrationType.telegram &&
            event.telegramBotToken!.isNotEmpty) {
          await telegram.sendMessage(
            "Connected Successfuly",
            channelId: event.chatId,
            botToken: event.telegramBotToken,
          );

          await storage.saveTelegramBotToken(event.telegramBotToken!);
          await storage.saveChatId(event.chatId!);
        }
        if (event.integrationType == IntegrationType.ai &&
            event.ollamaApiToken!.isNotEmpty) {
          await aiService.checkConnection(apiKey: event.ollamaApiToken);
          await storage.saveOllamaToken(event.ollamaApiToken!);
        }
        emit(OnboardingSuccess());
      } catch (e) {
        emit(OnboardingError("Invalid token or channel"));
      }
    });
    on<CheckIntegrationStatus>((
      CheckIntegrationStatus event,
      Emitter<OnboardingState> emit,
    ) async {
      emit(IntegrationStatusChecking());
      if (!await networkService.isOnline()) {
        emit(OnboardingError("Youre Currently Offline"));
        return;
      }
      final telegramStatus = await telegram.getMe();
      final ollamaStatus = await aiService.checkConnection();
      emit(
        IntegrationStatusSuccess(
          isAiConnected: ollamaStatus,
          isTelegramConnected: telegramStatus,
        ),
      );
    });
  }
}
