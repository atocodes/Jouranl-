import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:journal/features/journal/widgets/status_card.dart";
import "package:journal/features/onboarding/bloc/onboarding_bloc.dart";
import "package:journal/features/onboarding/bloc/onboarding_event.dart";
import "package:journal/features/onboarding/bloc/onboarding_state.dart";
import "package:journal/features/onboarding/widgets/integration_setup_sheet.dart";

class IntegrationStatusSection extends StatelessWidget {
  const IntegrationStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final isTelegramConnected = state is IntegrationStatusSuccess
              ? state.isTelegramConnected
              : false;

          final isAiConnected = state is IntegrationStatusSuccess
              ? state.isAiConnected
              : false;

          String telegramStatus;
          String aiStatus;

          if (state is IntegrationStatusChecking) {
            telegramStatus = "Checking...";
            aiStatus = "Checking...";
          } else {
            telegramStatus = isTelegramConnected
                ? "Connected"
                : "Not Connected";
            aiStatus = isAiConnected ? "Active" : "Not Active";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Integrations", style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: StatusCard(
                      icon: Icons.telegram,
                      label: "Telegram",
                      value: telegramStatus,
                      isActive: isTelegramConnected,
                      onRetry: () => context.read<OnboardingBloc>().add(
                        CheckIntegrationStatus(),
                      ),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => IntegrationSetupSheet(
                          type: IntegrationType.telegram,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatusCard(
                      icon: Icons.memory,
                      label: "AI",
                      value: aiStatus,
                      isActive: isAiConnected,
                      onRetry: () => context.read<OnboardingBloc>().add(
                        CheckIntegrationStatus(),
                      ),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) =>
                            IntegrationSetupSheet(type: IntegrationType.ai),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
