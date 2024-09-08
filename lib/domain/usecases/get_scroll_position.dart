import 'package:untitled/domain/repositories/pokemon_repository.dart';

class GetScrollPercentage {
  final PokemonRepository repository;

  GetScrollPercentage(this.repository);

  Future<double?> call() async {
    return await repository.getScrollPercentage();
  }
}
