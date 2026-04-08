enum AppTheme { light, dark }
class ThemeState {
  final AppTheme theme;

  const ThemeState(this.theme);

  bool get isDark => theme == AppTheme.dark;
}