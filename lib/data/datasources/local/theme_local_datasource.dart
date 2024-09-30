import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeLocalDataSource {
  Future<bool> isDarkMode();
  Future<void> setDarkMode(bool isDarkMode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isDarkMode() async {
    return sharedPreferences.getBool('is_dark_mode') ?? false;
  }

  @override
  Future<void> setDarkMode(bool isDarkMode) async {
    await sharedPreferences.setBool('is_dark_mode', isDarkMode);
  }
}
