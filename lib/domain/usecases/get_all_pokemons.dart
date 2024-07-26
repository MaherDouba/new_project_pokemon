import 'package:dartz/dartz.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetAllPokemons {
  final PokemonRepository repository;

  GetAllPokemons(this.repository);

  Future<Either<Exception, List<Pokemon>>> call() async {
  //  try {
      final pokemons = await repository.getAllPokemons();
      return Right(pokemons);
  // } catch (exception) {
  //   return Left(exception);
 //   }
  }
}
