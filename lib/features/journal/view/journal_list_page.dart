import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/core/services/local_storage_service.dart';
import 'package:journal/core/services/network_service.dart';
import 'package:journal/core/theme/theme_bloc.dart';
import 'package:journal/features/journal/bloc/journal_bloc.dart';
import 'package:journal/features/journal/bloc/journal_event.dart';
import 'package:journal/features/journal/view/journal_editor_page.dart';
import 'package:journal/features/journal/widgets/integration_status.dart';
import 'package:journal/features/journal/widgets/journal_list.dart';
import 'package:journal/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:journal/features/onboarding/bloc/onboarding_event.dart';

class JournalListPage extends StatefulWidget {
  final NetworkService networkService;
  final LocalStorageService localStorageService;
  const JournalListPage(
    this.networkService,
    this.localStorageService, {
    super.key,
  });

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  bool _isAutoPost = false;
  @override
  void initState() {
    super.initState();
    _isAutoPost = widget.localStorageService.isAutoPost;
    context.read<JournalBloc>().add(GetJournals());
    context.read<OnboardingBloc>().add(CheckIntegrationStatus());
  }

  void _updateIsAutoPost(bool value) async {
    await widget.localStorageService.setAutoPost(value);
    setState(() {
      _isAutoPost = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Auto Post ${value ? "Enabled" : "Disabled"}"),
        duration: Duration(seconds: 1),
      ),
      snackBarAnimationStyle: AnimationStyle.noAnimation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal+"),
        actions: [
          Row(
            children: [
              Icon(
                context.watch<ThemeCubit>().state.isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                size: 20,
              ),
              Switch(
                value: context.watch<ThemeCubit>().state.isDark,
                onChanged: (_) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ],
          ),

          const SizedBox(width: 8),

          Row(
            children: [
              const Icon(Icons.send, size: 20),
              Switch(value: _isAutoPost, onChanged: _updateIsAutoPost),
            ],
          ),

          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => MinimalJournalEditorPage())),
        label: const Text("Create Journal"),
        icon: const Icon(Icons.edit_document),
      ),
      body: StreamBuilder<bool>(
        stream: widget.networkService.networkStream,
        builder: (context, asyncSnapshot) {
          final theme = Theme.of(context);
          final isOnline = asyncSnapshot.data ?? false;

          return Stack(
            children: [
              Column(
                children: const [
                  SizedBox(height: 16),
                  IntegrationStatusSection(),
                  SizedBox(height: 16),
                  JournalListSection(),
                ],
              ),

              if (!isOnline)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: theme.colorScheme.errorContainer,
                    child: Text(
                      "No Internet Connection",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
