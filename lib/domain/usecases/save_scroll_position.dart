import '../repositories/pokemon_repository.dart';

class SaveScrollPercentage {
  final PokemonRepository repository;

  SaveScrollPercentage(this.repository);

  Future<void> call(double percentage) async {
    return await repository.saveScrollPercentage(percentage);
  }
}
