import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/core/services/local_storage_service.dart';
import 'package:journal/core/services/network_service.dart';
import 'package:journal/core/theme/bloc/theme_bloc.dart';
import 'package:journal/features/developer_profile/developer_profile_screen.dart';
import 'package:journal/features/journal/bloc/journal_bloc.dart';
import 'package:journal/features/journal/bloc/journal_event.dart';
import 'package:journal/features/journal/view/journal_editor_page.dart';
import 'package:journal/features/journal/widgets/integration_status.dart';
import 'package:journal/features/journal/widgets/journal_list.dart';
import 'package:journal/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:journal/features/onboarding/bloc/onboarding_event.dart';

class JournalListPage extends StatefulWidget {
  // final NetworkService networkService;
  const JournalListPage({super.key});

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  bool _isAutoPost = false;
  bool? _isOnline;
  final LocalStorageService localStorageService = LocalStorageService();
  final NetworkService _networkService = NetworkService();
  @override
  void initState() {
    super.initState();
    _isAutoPost = localStorageService.isAutoPost;
    context.read<JournalBloc>().add(GetJournals());
    context.read<OnboardingBloc>().add(CheckIntegrationStatus());
  }

  void _updateIsAutoPost(bool value) async {
    await localStorageService.setAutoPost(value);
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
        leading: Image.asset(
          "assets/icons/ico.jpg",
          width: MediaQuery.of(context).size.width * .3,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextButton.icon(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const DeveloperProfileScreen(),
              ),
              icon: const Icon(Icons.info_outline, size: 20),
              label: const Text(
                "Behind Journal +",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // Theme toggle
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state.isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              size: 22,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            tooltip: "Toggle Theme",
          ),

          // Telegram auto-post toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.telegram,
                  size: 22,
                  color: _isAutoPost ? Colors.blueAccent : null,
                ),
                Switch(
                  value: _isAutoPost,
                  onChanged: _updateIsAutoPost,
                  activeColor: Colors.blueAccent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: _networkService.networkStream,
            builder: (context, asyncSnapShot) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isOnline = asyncSnapShot.data;
                });
              });
              final bool isLoading = _isOnline == null;
              final bool isOnline = _isOnline == true;

              return CircleAvatar(
                maxRadius: 5,
                backgroundColor: isLoading
                    ? Colors.yellowAccent
                    : isOnline
                    ? Colors.greenAccent
                    : Colors.redAccent,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => MinimalJournalEditorPage())),
        label: const Text("Create Journal"),
        icon: const Icon(Icons.edit_document),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          IntegrationStatusSection(),
          SizedBox(height: 16),
          JournalListSection(isAutoPost: _isAutoPost),
        ],
      ),
    );
  }
}
