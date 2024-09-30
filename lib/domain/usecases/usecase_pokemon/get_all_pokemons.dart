import 'package:dartz/dartz.dart';
import '../../entities/pokemon.dart';
import '../../repositories/pokemon_repository.dart';

class GetAllPokemonsUsecase {
  final PokemonRepository repository;

  GetAllPokemonsUsecase(this.repository);

  Future<Either<Exception, List<Pokemon>>> call({required int page}) async {
    return await repository.getAllPokemons(page);
  }

  
}
