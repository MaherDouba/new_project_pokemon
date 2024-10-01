import '../../repositories/pokemon_repository.dart';

class GetCurrentPage {
  final PokemonRepository repository;

  GetCurrentPage(this.repository);

  Future<int> call() async {
    return await repository.getCurrentPage();
  }
}
