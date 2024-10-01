part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final String? scrollPokemonName;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const PokemonLoaded({
    required this.pokemons,
    this.scrollPokemonName,
    this.hasReachedMax = false,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  PokemonLoaded copyWith({
    List<Pokemon>? pokemons,
    String? scrollPokemonName,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons,
      scrollPokemonName: scrollPokemonName ?? this.scrollPokemonName,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
       isLoadingMore: isLoadingMore ?? this.isLoadingMore, 
    );
  }

  @override
  List<Object?> get props => [pokemons, scrollPokemonName, hasReachedMax, currentPage];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError({required this.message});

  @override
  List<Object> get props => [message];
}
