abstract class LanguageRepository {
  Future<String> getCurrentLanguage();
  Future<void> saveLanguage(String languageCode);
}
