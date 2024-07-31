import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  
  PokemonRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Exception, List<Pokemon>>> getAllPokemons() async {
    try {
    
      final remotePokemons = await remoteDataSource.getAllPokemons();
     
      await localDataSource.cachePokemons(remotePokemons);
      return Right(remotePokemons);
    } on ClientException {
      
      try {
        final cachedPokemons = await localDataSource.getCachedPokemons();
        return Right(cachedPokemons);
      } catch (cacheException) {
        return Left(Exception('Failed to fetch pokemons from local data source: ${cacheException.toString()}'));
      }
    } catch (exception) {
      return Left(Exception('Failed to fetch pokemons: ${exception.toString()}'));
    }
  }
}
