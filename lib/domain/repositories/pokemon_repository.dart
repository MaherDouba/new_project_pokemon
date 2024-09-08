import 'package:dartz/dartz.dart';
import '../entities/pokemon.dart';

abstract class PokemonRepository {
   Future<Either<Exception, List<Pokemon>>>  getAllPokemons(int page);
   Future<void> saveScrollPercentage(double percentage);
   Future<double?> getScrollPercentage();
   Future<void> saveCurrentPage(int page);
   Future<int> getCurrentPage();
}
