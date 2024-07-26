import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_all_pokemons.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetAllPokemons getAllPokemons;

  PokemonBloc({required this.getAllPokemons}) : super(PokemonInitial()) {
    on<GetPokemonsEvent>(_onGetPokemonsEvent);
  }

  Future<void> _onGetPokemonsEvent(GetPokemonsEvent event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    final failureOrPokemonList = await getAllPokemons();
    failureOrPokemonList.fold(
      (failure) {
        print('Error occurred: ${failure.toString()}');
        emit(PokemonError(message: failure.toString()));
      },
      (pokemonList) {
        emit(PokemonLoaded(pokemons: pokemonList));
      },
    );
  }
}
