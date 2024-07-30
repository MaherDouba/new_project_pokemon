import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetAllPokemonsUsecase {
  final PokemonRepository repository;

  GetAllPokemonsUsecase(this.repository);

  Future<Either<Exception, List<Pokemon>>> call() async {
    try {
      final pokemons = await repository.getAllPokemons();
      return Right(pokemons);
   } catch (exception) {
     return Left(ServerException as Exception);
   }
  }
}
