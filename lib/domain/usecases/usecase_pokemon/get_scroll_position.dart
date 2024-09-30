import '../../repositories/pokemon_repository.dart';

class GetScrollPosition {
  final PokemonRepository repository;

  GetScrollPosition(this.repository);

  Future<String?> call() async {
    return await repository.getScrollPosition();
  }
}
