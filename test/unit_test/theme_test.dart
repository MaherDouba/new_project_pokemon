import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/data/datasources/local/theme_local_datasource.dart';
import 'package:untitled/data/repositories/theme_repository_impl.dart';
import 'package:untitled/domain/usecases/usecases_theme/get_current_theme.dart';
import 'package:untitled/domain/usecases/usecases_theme/save_theme.dart';
import '../generate_mocks/mocks.mocks.dart';

void main (){
late ThemeLocalDataSourceImpl localDataSource;
late ThemeRepositoryImpl repo ;
late GetCurrentTheme getCurrentTheme ;
late SaveTheme saveTheme ;
late MockSharedPreferences mockSharedPreferences ;

setUp((){
  mockSharedPreferences = MockSharedPreferences();
  localDataSource = ThemeLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  repo = ThemeRepositoryImpl(localDataSource: localDataSource);
  getCurrentTheme = GetCurrentTheme(repo);
  saveTheme = SaveTheme(repo);

});

group('SaveThemeMode', (){
  test('should save the theme app to sharedprefrences', ()async{
    when(mockSharedPreferences.setBool('is_dark_mode', true))
        .thenAnswer((_) async => true);

    await saveTheme(true); 
    verify(mockSharedPreferences.setBool('is_dark_mode', true));
  });
});

group('GetCurrentTheme', () {
     test('should return the current theme from SharedPreferences', () async {
      when(mockSharedPreferences.getBool('is_dark_mode')).thenReturn(true);
      final result = await getCurrentTheme();
      expect(result, true);
    });

       test('should return default theme (light) when no theme is set', () async {
      when(mockSharedPreferences.getBool('is_dark_mode')).thenReturn(false);
      final result = await getCurrentTheme();
      expect(result, false);
    });
});

}