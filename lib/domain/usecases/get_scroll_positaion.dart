import 'package:untitled/domain/repositories/pokemon_repository.dart';

class GetScrollPosition {
  final PokemonRepository repository;

  GetScrollPosition(this.repository);

  Future<double?> call() async {
    return await repository.getScrollPosition();
  }
}
