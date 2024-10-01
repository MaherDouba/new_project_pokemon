import '../../repositories/theme_repository.dart';

class SaveTheme {
  final ThemeRepository repository;

  SaveTheme(this.repository);

  Future<void> call(bool isDarkMode) async {
    await repository.setDarkMode(isDarkMode);
  }
}
