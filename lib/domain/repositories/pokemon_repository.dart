import 'package:dartz/dartz.dart';
import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Exception, List<Pokemon>>> getAllPokemons(int page);
  Future<void> saveScrollPosition(int page, String pokemonName);
  Future<String?> getScrollPosition(int page);
  Future<void> saveCurrentPage(int page);
  Future<int> getCurrentPage();
}
