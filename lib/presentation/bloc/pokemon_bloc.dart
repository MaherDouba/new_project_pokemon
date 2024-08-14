import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_all_pokemons.dart';
part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetAllPokemonsUsecase getAllPokemons;

  PokemonBloc({required this.getAllPokemons}) : super(PokemonInitial()) {
    on<GetPokemonsEvent>(_onGetPokemonsEvent);
    on<LoadMorePokemonsEvent>(_onLoadMorePokemonsEvent);
  }


  

  Future<void> _onGetPokemonsEvent(GetPokemonsEvent event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());

    final failureOrPokemonList = await getAllPokemons();
    failureOrPokemonList.fold(
      (failure) {
        print('Error occurred: ${failure.toString()}');
        emit(PokemonError(message: 'Failed to fetch pokemons: ${failure.toString()}'));
      },
      (pokemonList) {      //added hasreachedmax  
        emit(PokemonLoaded(pokemons: pokemonList , hasReachedMax: false));
      },
    );
  }

 Future<void> _onLoadMorePokemonsEvent(LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded) {
      final currentState = state as PokemonLoaded;
      final currentPokemons = currentState.pokemons;

      // Try to load more pokemons
      final failureOrPokemonList = await getAllPokemons();
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'Failed to load more pokemons: ${failure.toString()}'));
        },
        (pokemonList) {
          if (pokemonList.isEmpty) {
            // No more pokemons available, reached the max
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            // Append the newly fetched pokemons to the existing list
            emit(PokemonLoaded(
              pokemons: currentPokemons + pokemonList,
              hasReachedMax: false,
            ));
          }
        },
      );
    }
  }

}
