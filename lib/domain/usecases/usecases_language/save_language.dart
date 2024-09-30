import '../../repositories/language_repository.dart';

class SaveLanguage {
  final LanguageRepository repository;

  SaveLanguage(this.repository);

  Future<void> call(String languageCode) async {
    await repository.saveLanguage(languageCode);
  }
}
