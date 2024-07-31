import 'package:dartz/dartz.dart';

import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Exception, List<Pokemon>>>  getAllPokemons();
}
