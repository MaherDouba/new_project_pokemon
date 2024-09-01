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
  final double scrollPosition;
  final bool hasReachedMax;

  const PokemonLoaded({
    required this.pokemons,
    required this.scrollPosition,
    this.hasReachedMax = false,
  });

  PokemonLoaded copyWith({
    List<Pokemon>? pokemons,
    double? scrollPosition,
    bool? hasReachedMax,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [pokemons, scrollPosition, hasReachedMax];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError({required this.message});

  @override
  List<Object> get props => [message];
}
