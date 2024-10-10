import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/data/datasources/local/language_local_datasource.dart';
import 'package:untitled/data/repositories/language_repository_impl.dart';
import 'package:untitled/domain/usecases/usecases_language/get_current_language.dart';
import 'package:untitled/domain/usecases/usecases_language/save_language.dart';
import '../generate_mocks/mocks.mocks.dart';

void main() {
  late LanguageLocalDataSourceImpl localDataSource;
  late LanguageRepositoryImpl repository;
  late GetCurrentLanguage getCurrentLanguageUseCase;
  late SaveLanguage saveLanguageUseCase;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = LanguageLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
    repository = LanguageRepositoryImpl(localDataSource: localDataSource);
    getCurrentLanguageUseCase = GetCurrentLanguage(repository);
    saveLanguageUseCase = SaveLanguage(repository);
  });

  group('GetCurrentLanguage', () {
    test('should return the current language from SharedPreferences', () async {
      // arrange
      when(mockSharedPreferences.getString('language_code')).thenReturn('ar');

      // act
      final result = await getCurrentLanguageUseCase();

      // assert
      expect(result, 'ar');
      verify(mockSharedPreferences.getString('language_code'));
    });

    test('should return default language (en) when no language is set', () async {
      // arrange
      when(mockSharedPreferences.getString('language_code')).thenReturn(null);

      // act
      final result = await getCurrentLanguageUseCase();

      // assert
      expect(result, 'en');
      verify(mockSharedPreferences.getString('language_code'));
    });
  });

  group('SaveLanguage', () {
    test('should save the language code to SharedPreferences', () async {
      // arrange
      when(mockSharedPreferences.setString('language_code', 'ar'))
          .thenAnswer((_) async => true);

      // act
      await saveLanguageUseCase('ar');

      // assert
      verify(mockSharedPreferences.setString('language_code', 'ar'));
    });
  });

}