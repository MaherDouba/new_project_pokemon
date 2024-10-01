import '../../repositories/pokemon_repository.dart';

class SaveScrollPosition {
  final PokemonRepository repository;

  SaveScrollPosition(this.repository);

  Future<void> call(String pokemonName) async {
    return await repository.saveScrollPosition( pokemonName);
  }
}
