abstract class ThemeRepository {
  Future<bool> isDarkMode();
  Future<void> setDarkMode(bool isDarkMode);
}
