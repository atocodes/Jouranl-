import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:journal/core/services/ai_service.dart';
import 'package:journal/core/services/local_storage_service.dart';
import 'package:journal/core/services/network_service.dart';
import 'package:journal/core/services/ollama_service.dart';
import 'package:journal/core/services/secure_storage_service.dart';
import 'package:journal/core/services/telegram_service.dart';
import 'package:journal/core/theme/theme_bloc.dart';
import 'package:journal/core/theme/theme_state.dart';
import 'package:journal/data/local/objectbox.dart';
import 'package:journal/data/models/journal_entry.dart';
import 'package:journal/features/journal/bloc/journal_bloc.dart';
import 'package:journal/features/journal/repo/journal_repo.dart';
import 'package:journal/features/journal/view/journal_list_page.dart';
import 'package:journal/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:journal/features/onboarding/view/telegram_setup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio();
  final connectivity = Connectivity();
  final internetConnection = InternetConnectionChecker.createInstance();
  final prefs = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();

  final objectBox = await ObjectBox.create();
  final journalBox = objectBox.store.box<JournalEntity>();

  final storageService = SecureStorageService(secureStorage);
  final telegramService = TelegramService(dio, storageService);
  final aiService = OllamaService(dio, storageService);
  final localStoragrService = LocalStorageService();
  await localStoragrService.init();
  final networkService = NetworkService(connectivity, internetConnection);

  final journalRepo = JournalRepo(journalBox);
  await networkService.init();

  runApp(
    MyApp(
      aiService: aiService,
      journalRepo: journalRepo,
      storageService: storageService,
      telegramService: telegramService,
      networkService: networkService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AIService aiService;
  final TelegramService telegramService;
  final SecureStorageService storageService;
  final JournalRepo journalRepo;
  final LocalStorageService localStorageService = LocalStorageService();
  final NetworkService networkService;

  MyApp({
    super.key,
    required this.aiService,
    required this.journalRepo,
    required this.storageService,
    required this.telegramService,
    required this.networkService,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(localStorageService)),
        BlocProvider<JournalBloc>(
          create: (_) => JournalBloc(
            aiService,
            telegramService,
            journalRepo,
            networkService,
            localStorageService,
          ),
        ),
        BlocProvider<OnboardingBloc>(
          create: (_) => OnboardingBloc(
            telegramService,
            storageService,
            localStorageService,
            aiService,
            networkService,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            home: Stack(
              children: [
                AppEntry(
                  storageService: storageService,
                  localStorageService: localStorageService,
                  networkService: networkService,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AppEntry extends StatefulWidget {
  final SecureStorageService storageService;
  final LocalStorageService localStorageService;
  final NetworkService networkService;
  const AppEntry({
    super.key,
    required this.storageService,
    required this.localStorageService,
    required this.networkService,
  });

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool? hasToken;
  bool? isFirstTimeRunning;
  bool? isSetupComplete;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {
    final setupComplete = widget.localStorageService.isSetupComplete();
    final token = await widget.storageService.getTelegramBotToken();
    setState(() {
      hasToken = token != null;
      isSetupComplete = setupComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSetupComplete == null) {
      return const Scaffold(
        body: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return isSetupComplete!
        ? JournalListPage(widget.networkService)
        : TelegramSetupPage(widget.networkService);
  }
}
