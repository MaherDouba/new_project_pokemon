import 'package:dartz/dartz.dart';
import '../../repositories/pokemon_repository.dart';
import '../../../core/error/failures.dart';

class GetAllPokemonNames {
  final PokemonRepository repository;

  GetAllPokemonNames(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getAllPokemonNames();
  }
}
