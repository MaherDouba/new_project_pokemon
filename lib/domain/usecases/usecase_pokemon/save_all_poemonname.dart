import 'package:dartz/dartz.dart';
import '../../repositories/pokemon_repository.dart';
import '../../../core/error/failures.dart';

class SaveAllPokemonNames {
  final PokemonRepository repository;

  SaveAllPokemonNames(this.repository);

  Future<Either<Failure, void>> call(List<String> names) async {
    return await repository.saveAllPokemonNames(names);
  }
}
