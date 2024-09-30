import '../../repositories/theme_repository.dart';

class GetCurrentTheme {
  final ThemeRepository repository;

  GetCurrentTheme(this.repository);

  Future<bool> call() async {
    return await repository.isDarkMode();
  }
}
