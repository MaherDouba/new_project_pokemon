import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/pokemon_local_datasource.dart';
import '../../data/datasources/pokemon_remote_datasource.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/usecases/get_all_pokemons.dart';
import '../../domain/usecases/get_scroll_position.dart';
import '../../domain/usecases/save_scroll_position.dart';
import '../../presentation/bloc/pokemon_bloc.dart';
import '../network/network_info.dart';

final GetIt getIt = GetIt.instance;
final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<http.Client>(() => http.Client());

  getIt.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(client: getIt() ),
  );

  getIt.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(sharedPreferences: getIt()),
  );

/*  getIt.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt()
    ),
  );*/

  // _____________Repository________________

  sl.registerLazySingleton<PokemonRepository>(() => PokemonRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

 /* getIt.registerLazySingleton<GetAllPokemonsUsecase>(
    () => GetAllPokemonsUsecase(getIt()),
  );*/

   // Use Cases
  sl.registerLazySingleton(() => SaveScrollPosition(sl()));
  sl.registerLazySingleton(() => GetScrollPosition(sl()));
  sl.registerLazySingleton(()=> GetAllPokemonsUsecase(sl()));

  getIt.registerFactory<PokemonBloc>(
    () => PokemonBloc(getAllPokemons: getIt()),
  );

  //!core
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl())); 

  //! External
 sl.registerLazySingleton(() => InternetConnectionChecker());


}
