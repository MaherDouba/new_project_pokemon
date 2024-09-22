import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Exception, List<Pokemon>>> getAllPokemons(int page);
  Future<void> saveScrollPosition(String pokemonName);
  Future<String?> getScrollPosition();
  Future<void> saveCurrentPage(int page);
  Future<int> getCurrentPage();
  Future<Either<Failure, void>> saveAllPokemonNames(List<String> names);
  Future<Either<Failure, List<String>>> getAllPokemonNames();
}