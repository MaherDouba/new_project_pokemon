import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_all_pokemons.dart';
import '../../domain/usecases/get_scroll_position.dart';
part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetAllPokemonsUsecase getAllPokemons;
  final GetScrollPosition getScrollPosition;
  
   

  PokemonBloc({required this.getAllPokemons, required this.getScrollPosition }) : super(PokemonInitial()) {
    on<GetPokemonsEvent>(_onGetPokemonsEvent);
    on<LoadMorePokemonsEvent>(_onLoadMorePokemonsEvent);
  }
  
  Future<void> _onGetPokemonsEvent(GetPokemonsEvent event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());

    final failureOrPokemonList = await getAllPokemons(page: 1);
    final savedScrollPosition = await getScrollPosition();
    
    failureOrPokemonList.fold(
      (failure) {
        emit(PokemonError(message: 'Failed to fetch pokemons: ${failure.toString()}'));
      },
      (pokemonList) {
        emit(PokemonLoaded(pokemons: pokemonList, scrollPosition: savedScrollPosition ?? 0.0, hasReachedMax: false));
      },
    );
  }

  int limit = 50;

  Future<void> _onLoadMorePokemonsEvent(LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && !(state as PokemonLoaded).hasReachedMax) {
      final currentState = state as PokemonLoaded;
      final currentPokemons = currentState.pokemons;
      final page = (currentState.pokemons.length / limit).ceil() + 1;
      
      final failureOrPokemonList = await getAllPokemons(page: page);
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'No internet connection. Please check your network settings and try again later'));
        },
        (pokemonList) {
          if (pokemonList.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(PokemonLoaded(
              pokemons: currentPokemons + pokemonList,
              scrollPosition: currentState.scrollPosition,
              hasReachedMax: false,
            ));
          }
        },
      );
    }
  }
  
}

