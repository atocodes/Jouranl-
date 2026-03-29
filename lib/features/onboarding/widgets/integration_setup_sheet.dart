import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:journal/features/onboarding/bloc/onboarding_event.dart';
import 'package:journal/features/onboarding/bloc/onboarding_state.dart';

class IntegrationSetupSheet extends StatefulWidget {
  final IntegrationType type;

  const IntegrationSetupSheet({super.key, required this.type});

  @override
  State<IntegrationSetupSheet> createState() => _IntegrationSetupSheetState();
}

class _IntegrationSetupSheetState extends State<IntegrationSetupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _botController = TextEditingController();
  final _channelController = TextEditingController();
  final _aiController = TextEditingController();
  bool _isLoading = false;
  String? errMsg;

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(GetTokens());
  }

  @override
  void dispose() {
    _botController.dispose();
    _channelController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = theme.visualDensity.baseSizeAdjustment.dy.abs() + 12;

    final isTelegram = widget.type == IntegrationType.telegram;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is TokensLoaded) {
          setState(() {
            _aiController.text = state.aiToken ?? "";
            _botController.text = state.botToken ?? "";
            _channelController.text = state.chatId ?? "";
          });
        }
        if (state is OnboardingLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
        if (state is OnboardingSuccess) {
          context.read<OnboardingBloc>().add(CheckIntegrationStatus());
          Navigator.of(context).pop();
        }
        if (state is OnboardingError) {
          setState(() {
            errMsg = state.message;
          });
        } else {
          setState(() {
            errMsg = null;
          });
        }
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing,
            spacing,
            spacing,
            MediaQuery.of(context).viewInsets.bottom + spacing,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                if (errMsg != null)
                  Text(
                    "$errMsg",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                Row(
                  children: [
                    Icon(
                      isTelegram ? Icons.telegram : Icons.smart_toy,
                      color: colors.primary,
                      size: 18,
                    ),
                    SizedBox(width: spacing / 2),
                    Text(
                      isTelegram ? "Telegram Setup" : "AI Token",
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // --- Fields ---
                if (isTelegram) ...[
                  TextFormField(
                    controller: _botController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: "Bot Token",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Required";
                      if (!v.contains(":")) return "Invalid token";
                      return null;
                    },
                  ),
                  SizedBox(height: spacing * 0.7),
                  TextFormField(
                    controller: _channelController,
                    decoration: const InputDecoration(
                      labelText: "Channel ID",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? "Required" : null,
                  ),
                ] else ...[
                  TextFormField(
                    controller: _aiController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: "Token",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Required";
                      if (v.length < 10) return "Too short";
                      return null;
                    },
                  ),
                ],

                SizedBox(height: spacing),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: spacing / 2),
                    Expanded(
                      child: _isLoading
                          ? SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            )
                          : FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<OnboardingBloc>().add(
                                    SubmitTelegramSetup(
                                      _botController.text,
                                      _channelController.text,
                                      _aiController.text,
                                      widget.type,
                                    ),
                                  );
                                }
                              },
                              child: const Text("Save"),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
