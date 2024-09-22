import 'package:dartz/dartz.dart';
import 'package:untitled/core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/local/pokemon_local_datasource.dart';
import '../datasources/remote/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Exception, List<Pokemon>>> getAllPokemons(int page) async {
    try {
      final localPokemons = await localDataSource.getCachedPokemons(page);
      if (localPokemons.isNotEmpty) {
        return Right(localPokemons);
      }
    } catch (e) {
      // Ignore cache exceptions
    }

    if (await networkInfo.isConnected) {
      try {
        return await _fetchAndCacheRemotePokemons(page);
      } catch (e) {
        return await _getLocalPokemonsCircular(page);
      }
    } else {
      return await _getLocalPokemonsCircular(page);
    }
  }

  Future<Either<Exception, List<Pokemon>>> _getLocalPokemonsCircular(int page) async {
    try {
      List<int> cachedPages = await localDataSource.getCachedPages();
      if (cachedPages.isEmpty) {
        return Left(EmptyCacheException());
      }

      int pageToFetch = cachedPages.contains(page) ? page : cachedPages.last;
      final localPokemons = await localDataSource.getCachedPokemons(pageToFetch);
      if (localPokemons.isEmpty) {
        pageToFetch = await localDataSource.getNextCachedPage(pageToFetch);
        final nextPagePokemons = await localDataSource.getCachedPokemons(pageToFetch);
        return Right(nextPagePokemons);
      }

      return Right(localPokemons);
    } catch (e) {
      return Left(EmptyCacheException());
    }
  }

  Future<Either<Exception, List<Pokemon>>> _fetchAndCacheRemotePokemons(int page) async {
    try {
      final remotePokemons = await remoteDataSource.getAllPokemons(page);
      await localDataSource.cachePokemons(remotePokemons, page);
      return Right(remotePokemons);
    } catch (e) {
      return Left(ServerException());
    }
  }

  @override
  Future<void> saveScrollPosition( String pokemonName) async {
    return await localDataSource.saveScrollPosition( pokemonName);
  }

  @override
  Future<String?> getScrollPosition() async {
    return await localDataSource.getScrollPosition();
  }

  @override
  Future<void> saveCurrentPage(int page) async {
    return await localDataSource.saveCurrentPage(page);
  }

  @override
  Future<int> getCurrentPage() async {
    return await localDataSource.getCurrentPage();
  }
  
  @override
  Future<Either<Failure, void>> saveAllPokemonNames(List<String> names) async {
    try {
      await localDataSource.saveAllPokemonNames(names);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllPokemonNames() async {
    try {
      final names = await localDataSource.getAllPokemonNames();
      return Right(names);
    } catch (e) {
      return Left(EmptyCacheFailure());
    }
  }

}
