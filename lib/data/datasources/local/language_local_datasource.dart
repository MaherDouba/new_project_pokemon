import 'package:shared_preferences/shared_preferences.dart';

abstract class LanguageLocalDataSource {
  Future<String> getCurrentLanguage();
  Future<void> saveLanguage(String languageCode);
}

class LanguageLocalDataSourceImpl implements LanguageLocalDataSource {
  final SharedPreferences sharedPreferences;

  LanguageLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getCurrentLanguage() async {
    return sharedPreferences.getString('language_code') ?? 'en';
  }

  @override
  Future<void> saveLanguage(String languageCode) async {
    await sharedPreferences.setString('language_code', languageCode);
  }
}
