import '../../repositories/language_repository.dart';

class GetCurrentLanguage {
  final LanguageRepository repository;

  GetCurrentLanguage(this.repository);

  Future<String> call() async {
    return await repository.getCurrentLanguage();
  }
}
