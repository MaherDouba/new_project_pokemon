import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/usecases/usecase_pokemon/get_all_pokemon_name.dart';
import '../../../domain/usecases/usecase_pokemon/get_all_pokemons.dart';
import '../../../domain/usecases/usecase_pokemon/get_current_page.dart';
import '../../../domain/usecases/usecase_pokemon/get_scroll_position.dart';
import '../../../domain/usecases/usecase_pokemon/save_all_poemonname.dart';
import '../../../domain/usecases/usecase_pokemon/save_current_page.dart';
import '../../../domain/usecases/usecase_pokemon/save_scroll_position.dart';
import '../../../domain/usecases/usecase_pokemon/search_pokemons.dart';


part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetAllPokemonsUsecase getAllPokemons;
  final GetScrollPosition getScrollPosition;
  final SaveScrollPosition saveScrollPosition;
  final SaveCurrentPage saveCurrentPage;
  final GetCurrentPage getCurrentPage;
  final SaveAllPokemonNames saveAllPokemonNames;
  final GetAllPokemonNames getAllPokemonNames;
  final SearchPokemons searchPokemons;
  int currentPage = 1;
  List<String> allPokemonNames = [];

  PokemonBloc({
    required this.getAllPokemons,
    required this.getScrollPosition,
    required this.saveScrollPosition,
    required this.saveCurrentPage,
    required this.getCurrentPage,
    required this.saveAllPokemonNames,
    required this.getAllPokemonNames,
    required this.searchPokemons,
  }) : super(PokemonInitial()) {
    on<GetPokemonsEvent>(_onGetPokemonsEvent);
    on<LoadMorePokemonsEvent>(_onLoadMorePokemonsEvent);
    on<LoadPreviousPokemonsEvent>(_onLoadPreviousPokemonsEvent);
    on<SaveScrollPositionEvent>(_onSaveScrollPositionEvent);
    on<SearchPokemonEvent>(_onSearchPokemonEvent);
  }

  Future<void> _onGetPokemonsEvent(GetPokemonsEvent event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    final savedNamesResult = await getAllPokemonNames();

    savedNamesResult.fold(
      (failure) {
      },
      (savedNames) {
        allPokemonNames = savedNames;
      }
    );

    final savedScrollPosition = await getScrollPosition();
    currentPage = await getCurrentPage();
    
    if (savedScrollPosition != null && allPokemonNames.isNotEmpty) {
      final index = allPokemonNames.indexOf(savedScrollPosition);
      if (index != -1) {
        currentPage = (index ~/ 50) + 1;
        await saveCurrentPage(currentPage);
        
        final pagesToLoad = _getPagesToLoad(index);
        final pokemonList = await _loadMultiplePages(pagesToLoad);
        
        emit(PokemonLoaded(
          pokemons: pokemonList,
          scrollPokemonName: savedScrollPosition,
          hasReachedMax: false,
          currentPage: currentPage,
        ));
      } /*else {
        await _loadInitialPage(emit);
      }*/
    } else {
      await _loadInitialPage(emit);
    }
  }

  Future<void> _loadInitialPage(Emitter<PokemonState> emit) async {
    final currentPageResult = await getAllPokemons(page: currentPage);

    currentPageResult.fold(
      (failure) {
        emit(PokemonError(message: 'Failed to fetch pokemons: ${failure.toString()}'));
      },
      (pokemonList) {
        _updateAllPokemonNames(pokemonList);
        emit(PokemonLoaded(
          pokemons: pokemonList,
          scrollPokemonName: null,
          hasReachedMax: false,
          currentPage: currentPage,
        ));
      },
    );
  }

  List<int> _getPagesToLoad(int index) {
    int currentPageIndex = (index ~/ 50) + 1;
    int positionInPage = index % 50;
    print("currentPageIndex $currentPageIndex, positionInPage $positionInPage");

    if (positionInPage <= 8 && currentPageIndex > 1) {
      return [currentPageIndex - 1, currentPageIndex];
    } else if (positionInPage >= 40 ) {
      return [currentPageIndex, currentPageIndex + 1];
    } else {
      return [currentPageIndex];
    }
  }

  Future<List<Pokemon>> _loadMultiplePages(List<int> pages) async {
    List<Pokemon> allPokemons = [];
    Set<int> loadedPages = Set<int>();

    for (var page in pages) {
      if (!loadedPages.contains(page)) {
        final result = await getAllPokemons(page: page);
        result.fold(
          (failure) {
            
          },
          (pokemonList) {
            allPokemons.addAll(pokemonList);
            loadedPages.add(page);
          },
        );
      }
    }
    return allPokemons;
  }

  void _updateAllPokemonNames(List<Pokemon> pokemonList) {
    bool isUpdated = false;
    for (var pokemon in pokemonList) {
      if (!allPokemonNames.contains(pokemon.name)) {
        allPokemonNames.add(pokemon.name);
        isUpdated = true;
      }
    }
    if (isUpdated) {
      saveAllPokemonNames(allPokemonNames);
    }
  }

  Future<void> _onLoadMorePokemonsEvent(LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && !(state as PokemonLoaded).hasReachedMax) {
      final currentState = state as PokemonLoaded;
      currentPage++;
      await saveCurrentPage(currentPage);
      final failureOrPokemonList = await getAllPokemons(page: currentPage);
      
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'No internet connection. Please check your network settings and try again later'));
        },
        (pokemonList) {
          if (pokemonList.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            _updateAllPokemonNames(pokemonList);
            emit(PokemonLoaded(
              pokemons:  [...currentState.pokemons, ...pokemonList],
              scrollPokemonName: null,
              hasReachedMax: false,
              currentPage: currentPage,
              isLoadingMore: false,
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
      final failureOrPokemonList = await getAllPokemons(page: currentPage);
      
      failureOrPokemonList.fold(
        (failure) {
          emit(PokemonError(message: 'Failed to load previous page'));
        },
        (pokemonList) {
          _updateAllPokemonNames(pokemonList);
          emit(PokemonLoaded(
            pokemons: pokemonList,
            scrollPokemonName: pokemonList.last.name,
            hasReachedMax: false,
            currentPage: currentPage,
          ));
        },
      );
    }
  }

  Future<void> _onSaveScrollPositionEvent(SaveScrollPositionEvent event, Emitter<PokemonState> emit) async {
    await saveScrollPosition(event.pokemonName);
    if (!allPokemonNames.contains(event.pokemonName)) {
      allPokemonNames.add(event.pokemonName);
      await saveAllPokemonNames(allPokemonNames);
    }
    print("Saved scroll position: ${event.pokemonName}");
    print("All Pokemon names: $allPokemonNames");
  }

    Future<void> _onSearchPokemonEvent(SearchPokemonEvent event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    final result = await searchPokemons(event.query);
    result.fold(
      (failure) => emit(PokemonError(message: 'Failed to search pokemons')),
      (pokemons) => emit(PokemonLoaded(pokemons: pokemons, hasReachedMax: true, currentPage: 1)),
    );
  }
}
