import 'package:dartz/dartz.dart';
import 'package:untitled/core/error/exceptions.dart';
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
    final localPokemons = await localDataSource.getCachedPokemons();
  
    if (localPokemons.isNotEmpty && page== 1) {
    //  await localDataSource.getScrollPosition();
      print("localPokemons is not empty and the data is from it."); 
      return Right(localPokemons);
    }
  } on EmptyCacheException {
    print("Cache is empty, fetching from remote.");
  } catch (e) {
    print("Failed to fetch pokemons from cache: $e");
    return Left(ServerException());
  }

 if ( await networkInfo.isConnected ) {
      print('Network connection status: ${await networkInfo.isConnected}');
      
      return await _fetchAndCacheRemotePokemons(page);
    } else {
      print("No network connection, unable to fetch from remote.");
      return Left(OfflineException());
    }
  }

 Future<Either<Exception, List<Pokemon>>> _fetchAndCacheRemotePokemons(int page) async {
    try {
      print('........Trying to fetch from remote............');
      final remotePokemons = await remoteDataSource.getAllPokemons(page+1);
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
    print("save scroll position");
    return await localDataSource.saveScrollPosition(position);
  }

  @override
  Future<double?> getScrollPosition() async {
    return await localDataSource.getScrollPosition();
  }
}

 
/**
 * 
 *   @override
  Future<Either<Exception, List<Pokemon>>> getAllPokemons(int page, {bool forceRemote = false}) async {
    if (!forceRemote) {
      try {
        final localPokemons = await localDataSource.getCachedPokemons();
        if (localPokemons.isNotEmpty) {
          print("عرض البيانات المحفوظة محليًا");
          return Right(localPokemons);
        }
      } catch (e) {
        print("فشل في جلب البيانات من التخزين المحلي: $e");
      }
    }

    if (await networkInfo.isConnected) {
      return await _fetchAndCacheRemotePokemons(page);
    } else {
      print("لا يوجد اتصال بالإنترنت");
      return Left(OfflineException());
    }
  }
 * 
 * 
 */
 