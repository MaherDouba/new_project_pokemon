import '../../domain/repositories/language_repository.dart';
import '../datasources/local/language_local_datasource.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageLocalDataSource localDataSource;

  LanguageRepositoryImpl({required this.localDataSource});

  @override
  Future<String> getCurrentLanguage() async {
    return await localDataSource.getCurrentLanguage();
  }

  @override
  Future<void> saveLanguage(String languageCode) async {
    await localDataSource.saveLanguage(languageCode);
  }
}
