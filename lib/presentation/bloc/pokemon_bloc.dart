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
    print("currentPage_var from  get_pokemon_event = ${currentPage_var}");
    final savedScrollPosition = await getScrollPosition(currentPage_var);
    print("saved scroll position from  get_pokemon_event = $savedScrollPosition");
    final currentPageResult = await getAllPokemons(page: currentPage_var);

    currentPageResult.fold(
      (failure) {
        emit(PokemonError(message: 'Failed to fetch pokemons: ${failure.toString()}'));
      },
      (pokemonList) {
        emit(PokemonLoaded(
          pokemons: pokemonList,
          scrollPokemonName: savedScrollPosition,
          hasReachedMax: false,
          currentPage: currentPage_var,
        ));
      },
    );
  }



  Future<void> _onLoadMorePokemonsEvent(LoadMorePokemonsEvent event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded && !(state as PokemonLoaded).hasReachedMax) {
      final currentState = state as PokemonLoaded;
      currentPage_var++;
      print("currentPage_var ++ = $currentPage_var");
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
              pokemons: currentPage + pokemonList,
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
       print("get page from on load previous = $currentPage_var .....");
       currentPage_var--;
       print("1__currentPage_var-- = $currentPage_var");
      await saveCurrentPage(currentPage_var);
       print("2__currentPage_var-- = $currentPage_var");
      final failureOrPokemonList = await getAllPokemons(page: currentPage_var);
       print("3__currentPage_var-- = $currentPage_var");
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
    if (state is PokemonLoaded) {
      emit((state as PokemonLoaded).copyWith(scrollPokemonName: event.pokemonName));
    }
  }
}
