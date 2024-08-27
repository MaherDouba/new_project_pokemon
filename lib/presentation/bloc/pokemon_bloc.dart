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

    final failureOrPokemonList = await getAllPokemons(page: 1);
     
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
 int limit = 50;
 Future<void> _onLoadMorePokemonsEvent(LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && !(state as PokemonLoaded).hasReachedMax) {
      final currentState = state as PokemonLoaded;
      final currentPokemons = currentState.pokemons;
       final page = (currentState.pokemons.length / limit).ceil() + 1;  
      // Try to load more pokemons
      
      final failureOrPokemonList = await getAllPokemons(page:page);   
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'No internet connection. Please check your network settings and try again later'));
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
