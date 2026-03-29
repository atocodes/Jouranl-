abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;
  OnboardingError(this.message);
}

class TokensLoaded extends OnboardingState {
  final String? chatId;
  final String? botToken;
  final String? aiToken;
  TokensLoaded(this.chatId, this.botToken, this.aiToken);
}

class IntegrationStatusChecking extends OnboardingState {}

class IntegrationStatusSuccess extends OnboardingState {
  final bool isTelegramConnected;
  final bool isAiConnected;

  IntegrationStatusSuccess({
    required this.isTelegramConnected,
    required this.isAiConnected,
  });
}

class IntegrationStatusFailure extends OnboardingState {
  String? message;
  IntegrationStatusFailure({this.message});
}
