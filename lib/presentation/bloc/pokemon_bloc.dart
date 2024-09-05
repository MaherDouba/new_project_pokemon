import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_all_pokemons.dart';
import '../../domain/usecases/get_current_page.dart';
import '../../domain/usecases/get_scroll_position.dart';
import '../../domain/usecases/save_current_page.dart';
part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetAllPokemonsUsecase getAllPokemons;
  final GetScrollPosition getScrollPosition;
  final SaveCurrentPage saveCurrentPage;
  final GetCurrentPage getCurrentPage;
  int currentPage = 1; 

   PokemonBloc({
    required this.getAllPokemons, 
    required this.getScrollPosition,
    required this.saveCurrentPage,
    required this.getCurrentPage,
  }) : super(PokemonInitial()) {
    on<GetPokemonsEvent>(_onGetPokemonsEvent);
    on<LoadMorePokemonsEvent>(_onLoadMorePokemonsEvent);
    on<LoadPreviousPokemonsEvent>(_onLoadPreviousPokemonsEvent);
  }
  
  Future<void> _onGetPokemonsEvent(GetPokemonsEvent event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    currentPage = await getCurrentPage();
    final failureOrPokemonList = await getAllPokemons(page: currentPage);
    final savedScrollPosition = await getScrollPosition();
    
    failureOrPokemonList.fold(
      (failure) {
        emit(PokemonError(message: 'Failed to fetch pokemons: ${failure.toString()}'));
      },
      (pokemonList) {
        emit(PokemonLoaded(
          pokemons: pokemonList, 
          scrollPosition: savedScrollPosition ?? 0.0,
          hasReachedMax: false ,
          currentPage: currentPage,));
      },
    );
  }

  int limit = 50;

  Future<void> _onLoadMorePokemonsEvent(LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && !(state as PokemonLoaded).hasReachedMax) {
      final currentState = state as PokemonLoaded;
      currentPage++;
      await saveCurrentPage(currentPage);
      final currentPokemons = currentState.pokemons;
     // final page = (currentState.pokemons.length / limit).ceil() + 1;
      
      final failureOrPokemonList = await getAllPokemons(page: currentPage);
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
              currentPage: currentPage,
            ));
          }
        },
      );
    }
  }

    Future<void> _onLoadPreviousPokemonsEvent(LoadPreviousPokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && currentPage > 1) {
      currentPage--;
      await saveCurrentPage(currentPage);
      
     // emit(PokemonLoading());
      
      final failureOrPokemonList = await getAllPokemons(page: currentPage);
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'Failed to load previous page'));
        },
        (pokemonList) {
          emit(PokemonLoaded(
            pokemons: pokemonList,
            scrollPosition: 0.0,
            hasReachedMax: false,
            currentPage: currentPage,
          ));
        },
      );
    }
  }
  
}

