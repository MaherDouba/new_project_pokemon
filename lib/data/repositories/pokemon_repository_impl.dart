import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  
  PokemonRepositoryImpl({required this.localDataSource, required this.remoteDataSource});

  @override
  Future<List<Pokemon>> getAllPokemons() async {
    return await remoteDataSource.getAllPokemons();
  }
}
