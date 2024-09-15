import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_all_pokemons.dart';
import '../../domain/usecases/get_current_page.dart';
import '../../domain/usecases/get_scroll_position.dart';
import '../../domain/usecases/save_current_page.dart';
import '../../domain/usecases/save_scroll_position.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetAllPokemonsUsecase getAllPokemons;
  final GetScrollPosition getScrollPosition;
  final SaveScrollPosition saveScrollPosition;
  final SaveCurrentPage saveCurrentPage;
  final GetCurrentPage getCurrentPage;
  int currentPage_var = 1;
  
  PokemonBloc({
    required this.getAllPokemons, 
    required this.getScrollPosition,
    required this.saveScrollPosition,
    required this.saveCurrentPage,
    required this.getCurrentPage,
  }) : super(PokemonInitial()) {
    on<GetPokemonsEvent>(_onGetPokemonsEvent);
    on<LoadMorePokemonsEvent>(_onLoadMorePokemonsEvent);
    on<LoadPreviousPokemonsEvent>(_onLoadPreviousPokemonsEvent);
    on<SaveScrollPositionEvent>(_onSaveScrollPositionEvent);
  }
  
Future<void> _onGetPokemonsEvent(GetPokemonsEvent event, Emitter<PokemonState> emit) async {
  emit(PokemonLoading());
  currentPage_var = await getCurrentPage();

  final savedScrollPosition = await getScrollPosition(currentPage_var);
  print("savedscrollposition $savedScrollPosition");
  
  List<Pokemon> currentPagePokemons = [];
  List<Pokemon> previousPagePokemons = [];
  List<Pokemon> nextPagePokemons = [];

  final currentPageResult = await getAllPokemons(page: currentPage_var);
  currentPageResult.fold(
    (failure) {
      emit(PokemonError(message: 'Failed to fetch pokemons: ${failure.toString()}'));
      return;
    },
    (pokemonList) {
      currentPagePokemons = pokemonList;
    
    },
  );

  if (savedScrollPosition != null) {
    final savedIndex = currentPagePokemons.indexWhere((pokemon) => pokemon.name == savedScrollPosition);
    print("savedindex $savedIndex");
      final lastPokemon = currentPagePokemons.last; 
      print("lastPokemon $lastPokemon");
  final lastIndex = currentPagePokemons.indexOf(lastPokemon); 
  print("lastIndex $lastIndex");  
  print("currentPagePokemons.length ${currentPagePokemons.length}");
    if (savedIndex < 7 && currentPage_var > 1) {
      final previousPageResult = await getAllPokemons(page: currentPage_var - 1);
      previousPageResult.fold(
        (failure) {
        },
        (pokemonList) {
          previousPagePokemons = pokemonList;
          
        },
      );
    }
    
    else if (savedIndex >= currentPagePokemons.length - 6) {
      final nextPageResult = await getAllPokemons(page: currentPage_var + 1);
      print("currentPagePokemons.length - 6 ${currentPagePokemons.length - 6}");
      nextPageResult.fold(
        (failure) {
        },
        (pokemonList) {
          nextPagePokemons = pokemonList;
        },
      );
    }
  }


  emit(PokemonLoaded(
    pokemons: [...previousPagePokemons, ...currentPagePokemons ,...nextPagePokemons],
    scrollPokemonName: savedScrollPosition,
    hasReachedMax: false,
    currentPage: currentPage_var,
  ));
}



  Future<void> _onLoadMorePokemonsEvent(LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && !(state as PokemonLoaded).hasReachedMax) {
      final currentState = state as PokemonLoaded;
      currentPage_var++;
      await saveCurrentPage(currentPage_var);
     final currentPage = currentState.pokemons;
      final failureOrPokemonList = await getAllPokemons(page: currentPage_var);
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'No internet connection. Please check your network settings and try again later'));
        },
        (pokemonList) {
          if (pokemonList.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(PokemonLoaded(
              pokemons: currentPage+pokemonList,
              scrollPokemonName: null,
              hasReachedMax: false,
              currentPage: currentPage_var,
            ));
          }
        },
      );
    }
  }

  Future<void> _onLoadPreviousPokemonsEvent(LoadPreviousPokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && currentPage_var > 1) {
      currentPage_var--;
      await saveCurrentPage(currentPage_var);
      
      final failureOrPokemonList = await getAllPokemons(page: currentPage_var);
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'Failed to load previous page'));
        },
        (pokemonList) {
          emit(PokemonLoaded(
            pokemons: pokemonList,
            scrollPokemonName: null,
            hasReachedMax: false,
            currentPage: currentPage_var,
          ));
        },
      );
    }
  }

  Future<void> _onSaveScrollPositionEvent(SaveScrollPositionEvent event, Emitter<PokemonState> emit) async {
    await saveScrollPosition(event.page, event.pokemonName);
  }
}
