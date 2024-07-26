import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/pokemon_remote_datasource.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/usecases/get_all_pokemons.dart';
import '../../presentation/bloc/pokemon_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  getIt.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetAllPokemons(getIt()),
  );
  getIt.registerFactory(
    () => PokemonBloc(getAllPokemons: getIt()),
  );
}
