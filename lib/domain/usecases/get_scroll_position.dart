import '../repositories/pokemon_repository.dart';

class GetScrollPosition {
  final PokemonRepository repository;

  GetScrollPosition(this.repository);

  Future<String?> call(int page) async {
    return await repository.getScrollPosition(page);
  }
}
