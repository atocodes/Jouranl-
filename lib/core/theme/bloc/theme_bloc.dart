import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/core/services/local_storage_service.dart';
import 'package:journal/core/theme/bloc/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final LocalStorageService storage;

  ThemeCubit(this.storage)
      : super(
          ThemeState(
            storage.getTheme() == 'dark'
                ? AppTheme.dark
                : AppTheme.light,
          ),
        );

  void toggleTheme() async {
    final newTheme =
        state.isDark ? AppTheme.light : AppTheme.dark;

    await storage.setTheme(newTheme.name);

    emit(ThemeState(newTheme));
  }

  void setTheme(AppTheme theme) async {
    await storage.setTheme(theme.name);

    emit(ThemeState(theme));
  }
}