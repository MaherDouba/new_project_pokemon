import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
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
      print('Trying to fetch from remote');
      final remotePokemons = await remoteDataSource.getAllPokemons();
      print('Fetched ${remotePokemons.length} pokemons from remote');
      await localDataSource.cachePokemons(remotePokemons);
      print('Cached ${remotePokemons.length} pokemons');
      return Right(remotePokemons);
    } on http.ClientException catch (e) {
      print('ClientException: ${e.toString()}');
      try {
        print('Trying to fetch from local cache');
        final cachedPokemons = await localDataSource.getCachedPokemons();
        print('Fetched ${cachedPokemons.length} pokemons from local cache');
        return Right(cachedPokemons);
      } catch (cacheException) {
        print('CacheException: ${cacheException.toString()}');
        return Left(Exception('Failed to fetch pokemons from local data source: ${cacheException.toString()}'));
      }
    } on HandshakeException catch (e) {
      print('HandshakeException: ${e.toString()}');
      try {
        print('Trying to fetch from local cache');
        final cachedPokemons = await localDataSource.getCachedPokemons();
        print('Fetched ${cachedPokemons.length} pokemons from local cache');
        return Right(cachedPokemons);
      } catch (cacheException) {
        print('CacheException: ${cacheException.toString()}');
        return Left(Exception('Failed to fetch pokemons from local data source: ${cacheException.toString()}'));
      }
    } catch (exception) {
      print('General Exception: ${exception.toString()}');
      return Left(Exception('Failed to fetch pokemons from data source: ${exception.toString()}'));
    }
  }
}
