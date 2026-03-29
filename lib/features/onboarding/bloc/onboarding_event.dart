abstract class OnboardingEvent {}

enum IntegrationType { telegram, ai, all }

class SubmitTelegramSetup extends OnboardingEvent {
  final String? telegramBotToken;
  final String? chatId;
  final String? ollamaApiToken;
  IntegrationType integrationType = IntegrationType.all;

  SubmitTelegramSetup(
    this.telegramBotToken,
    this.chatId,
    this.ollamaApiToken,
    this.integrationType,
  );
}

class GetTokens extends OnboardingEvent {}

class CheckIntegrationStatus extends OnboardingEvent {}
