import '../repositories/pokemon_repository.dart';

class SaveScrollPosition {
  final PokemonRepository repository;

  SaveScrollPosition(this.repository);

  Future<void> call(double position) async {
    return await repository.saveScrollPosition(position);
  }
}
