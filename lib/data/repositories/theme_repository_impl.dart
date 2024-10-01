import '../../domain/repositories/theme_repository.dart';
import '../datasources/local/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isDarkMode() async {
    return await localDataSource.isDarkMode();
  }

  @override
  Future<void> setDarkMode(bool isDarkMode) async {
    await localDataSource.setDarkMode(isDarkMode);
  }
}
