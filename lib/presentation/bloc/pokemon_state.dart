part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final double scrollPercentage;
  final bool hasReachedMax;
  final int currentPage;

  const PokemonLoaded(  {
    required this.pokemons,
    required this.scrollPercentage,
    this.hasReachedMax = false,
    required this.currentPage,
  });

  PokemonLoaded copyWith({
    List<Pokemon>? pokemons,
    double? scrollPercentage,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons,
      scrollPercentage: scrollPercentage ?? this.scrollPercentage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [pokemons, scrollPercentage, hasReachedMax, currentPage ];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError({required this.message});

  @override
  List<Object> get props => [message];
}
