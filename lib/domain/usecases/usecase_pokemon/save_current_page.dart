import '../../repositories/pokemon_repository.dart';

class SaveCurrentPage {
  final PokemonRepository repository;

  SaveCurrentPage(this.repository);

  Future<void> call(int page) async {
    return await repository.saveCurrentPage(page);
  }
}
