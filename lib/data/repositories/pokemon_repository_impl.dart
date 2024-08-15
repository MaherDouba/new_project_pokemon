import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';

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
  Future<Either<Exception, List<Pokemon>>> getAllPokemons() async {
    try {
      final localPokemons = await localDataSource.getCachedPokemons();
      if (localPokemons.isNotEmpty) {
        print("localPokemons is not empty and the data is from it.");
        _fetchAndCacheRemotePokemons();
        return Right(localPokemons);
      }
      if (await networkInfo.isConnected) {
        print('Network connection status: ${await networkInfo.isConnected}');
        return await _fetchAndCacheRemotePokemons();
      } else {
        print("No network connection, unable to fetch from remote.");
        return Left(OfflineException());
      }
    } catch (e) {
      print("Failed to fetch pokemons: $e");
      return Left(ServerException());
    }
  }
  Future<Either<Exception, List<Pokemon>>> _fetchAndCacheRemotePokemons() async {
    try {
      print('........Trying to fetch from remote............');
      final remotePokemons = await remoteDataSource.getAllPokemons();
      print('Fetched ${remotePokemons.length} pokemons from remote');
      await localDataSource.cachePokemons(remotePokemons);
      print('Cached ${remotePokemons.length} pokemons');
      return Right(remotePokemons);
    } catch (e) {
      print("Failed to fetch from remote source: $e");
      return Left(ServerException());
    }
  }

  @override
  Future<void> saveScrollPosition(double position) async {
    return await localDataSource.saveScrollPosition(position);
  }

  @override
  Future<double?> getScrollPosition() async {
    return await localDataSource.getScrollPosition();
  }
}



/*


/*

 import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo
  });

  @override
  Future<Either<Exception, List<Pokemon>>> getAllPokemons() async {
    
   if(await networkInfo.isConnected){
      print('Network connection status: ${await networkInfo.isConnected}');

    try {
      final localPokemons = await localDataSource.getCachedPokemons();
      if (localPokemons.isNotEmpty){
        print("localpokemons is not empty and the data form it ");
         return Right(localPokemons);
      }
      print('........Trying to fetch from remote............');
      final remotePokemons = await remoteDataSource.getAllPokemons();
      print('Fetched ${remotePokemons.length} pokemons from remote');
      await localDataSource.cachePokemons(remotePokemons);
       print('Cached ${remotePokemons.length} pokemons');
      return Right(remotePokemons);
    } on ServerException {
      return Left(ServerException());
    }on OfflineException {
    return Right(localDataSource.getCachedPokemons() as List<Pokemon>);
  }

  
   }else {
    try  {
      print('------------Trying to fetch from local cache-------------');
      final localPokemons = await localDataSource.getCachedPokemons();
      print('Fetched ${localPokemons.length} pokemons from local cache');
      return Right(localPokemons);
    } on EmptyCacheException {
      return Left(EmptyCacheException());
    }
   }

  }


  @override
  Future<void> saveScrollPosition(double position) async {
    return await localDataSource.saveScrollPosition(position);
  }

  @override
  Future<double?> getScrollPosition() async {
    return await localDataSource.getScrollPosition();
  }
}

 */

 */