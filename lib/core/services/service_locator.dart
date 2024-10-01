import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/language_local_datasource.dart';
import '../../data/datasources/local/pokemon_local_datasource.dart';
import '../../data/datasources/local/theme_local_datasource.dart';
import '../../data/datasources/remote/pokemon_remote_datasource.dart';
import '../../data/repositories/language_repository_impl.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/repositories/language_repository.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/usecases/usecase_pokemon/get_all_pokemon_name.dart';
import '../../domain/usecases/usecase_pokemon/get_all_pokemons.dart';
import '../../domain/usecases/usecase_pokemon/get_current_page.dart';
import '../../domain/usecases/usecase_pokemon/get_scroll_position.dart';
import '../../domain/usecases/usecase_pokemon/save_all_poemonname.dart';
import '../../domain/usecases/usecase_pokemon/save_current_page.dart';
import '../../domain/usecases/usecase_pokemon/save_scroll_position.dart';
import '../../domain/usecases/usecase_pokemon/search_pokemons.dart';
import '../../domain/usecases/usecases_language/get_current_language.dart';
import '../../domain/usecases/usecases_language/save_language.dart';
import '../../domain/usecases/usecases_theme/get_current_theme.dart';
import '../../domain/usecases/usecases_theme/save_theme.dart';
import '../../presentation/bloc/language_bloc/languge_bloc.dart';
import '../../presentation/bloc/pokemons_bloc/pokemon_bloc.dart';
import '../../presentation/bloc/theme_bloce/theme_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
  // Bloc
  sl.registerFactory(() => PokemonBloc(
    getAllPokemons: sl(),
    getScrollPosition: sl(),
    saveScrollPosition: sl(),
    saveCurrentPage: sl(),
    getCurrentPage: sl(),
    saveAllPokemonNames: sl(),
    getAllPokemonNames: sl(),
    searchPokemons: sl()));
  
  sl.registerFactory(() => LanguageBloc(getCurrentLanguage: sl(), saveLanguage: sl()));
  sl.registerFactory(() => ThemeBloc(getCurrentTheme: sl(), saveTheme: sl()));

  // Use cases pokemon 
  sl.registerLazySingleton(() => SaveScrollPosition(sl()));
  sl.registerLazySingleton(() => GetScrollPosition(sl()));
  sl.registerLazySingleton(() => GetAllPokemonsUsecase(sl()));
  sl.registerLazySingleton(() => SaveCurrentPage(sl()));
  sl.registerLazySingleton(() => GetCurrentPage(sl()));
  sl.registerLazySingleton(() => SaveAllPokemonNames(sl()));
  sl.registerLazySingleton(() => GetAllPokemonNames(sl()));
  sl.registerLazySingleton(() => SearchPokemons(sl()));
  
  // Use cases language 
  sl.registerLazySingleton(() => GetCurrentLanguage(sl()));
  sl.registerLazySingleton(() => SaveLanguage(sl()));
 
  // Use cases theme 
  sl.registerLazySingleton(() => GetCurrentTheme(sl()));
  sl.registerLazySingleton(() => SaveTheme(sl()));

  // Repository
  sl.registerLazySingleton<PokemonRepository>(() => PokemonRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<LanguageRepository>(() => LanguageRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<PokemonRemoteDataSource>(() => PokemonRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PokemonLocalDataSource>(() => PokemonLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<LanguageLocalDataSource>(() => LanguageLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<ThemeLocalDataSource>(() => ThemeLocalDataSourceImpl(sharedPreferences: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
