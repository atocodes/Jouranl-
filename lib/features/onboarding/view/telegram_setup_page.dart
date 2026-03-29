import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:journal/core/services/local_storage_service.dart";
import "package:journal/core/services/network_service.dart";
import "package:journal/features/journal/view/journal_list_page.dart";
import "package:journal/features/onboarding/bloc/onboarding_bloc.dart";
import "package:journal/features/onboarding/bloc/onboarding_event.dart";
import "package:journal/features/onboarding/bloc/onboarding_state.dart";
import "package:journal/features/onboarding/widgets/step_section.dart";
import "package:url_launcher/url_launcher.dart";

class TelegramSetupPage extends StatefulWidget {
  final NetworkService networkService;
  final LocalStorageService localStorage;
  const TelegramSetupPage(this.networkService, this.localStorage, {super.key});

  @override
  State<TelegramSetupPage> createState() => _TelegramSetupPageState();
}

class _TelegramSetupPageState extends State<TelegramSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _chatIdController = TextEditingController();
  final _ollamaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(GetTokens());
  }

  Future<void> openBotFather() async {
    final uri = Uri.parse("https://t.me/BotFather");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> openOllamaKeys() async {
    final uri = Uri.parse("https://ollama.com/settings/keys");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final token = _tokenController.text.trim();
    final chatId = _chatIdController.text.trim();
    final ollamaApiKey = _ollamaController.text.trim();

    context.read<OnboardingBloc>().add(
      SubmitTelegramSetup(token, chatId, ollamaApiKey, IntegrationType.all),
    );
  }

  void _navToHome() async {
    await widget.localStorage.completeSetup();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => JournalListPage(widget.networkService,widget.localStorage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to Journal+",
          style: theme.textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<bool>(
        stream: widget.networkService.networkStream,
        builder: (context, asyncSnapshot) {
          final isOnline = asyncSnapshot.data ?? false;
          print(isOnline);

          return BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingLoading) setState(() => _isLoading = true);
              if (state is OnboardingSuccess) _navToHome();
              if (state is OnboardingError || state is TokensLoaded)
                setState(() => _isLoading = false);
              if (state is TokensLoaded) {
                _chatIdController.text = state.chatId ?? "";
                _ollamaController.text = state.aiToken ?? "";
                _tokenController.text = state.botToken ?? "";
              }
            },
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isOnline)
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: theme.colorScheme.errorContainer,
                                child: Text(
                                  "No Internet Connection",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            Text(
                              "Getting Started with Journal+",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "AI-powered journaling with automatic Telegram publishing.",
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Set up your Telegram bot and AI to get started.\nThis is a one-time setup.",
                              style: theme.textTheme.bodyMedium,
                            ),

                            const SizedBox(height: 24),

                            /// 🔹 STEP 1
                            StepSection(
                              title: "1. Create Telegram Bot",
                              actionText: "Open BotFather",
                              onAction: openBotFather,
                              child: TextFormField(
                                controller: _tokenController,
                                decoration: const InputDecoration(
                                  labelText: "Bot Token",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "Required";
                                  if (!value.contains(":"))
                                    return "Invalid token";
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            /// 🔹 STEP 2
                            StepSection(
                              title: "2. Connect Channel",
                              child: TextFormField(
                                controller: _chatIdController,
                                decoration: const InputDecoration(
                                  labelText: "Channel Username",
                                  hintText: "@your_channel",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "Required";
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Make sure your bot is admin in the channel",
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            StepSection(
                              title: "3. AI API Key",
                              actionText: "Get API Key",
                              onAction: openOllamaKeys,
                              child: TextFormField(
                                controller: _ollamaController,
                                decoration: const InputDecoration(
                                  labelText: "API Key",
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Api Key is required ";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isOnline && !_isLoading
                                    ? _submit
                                    : null,
                                child: _isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                      )
                                    : const Text("Save & Continue"),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: _navToHome,
                                child: Text("Skip"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
