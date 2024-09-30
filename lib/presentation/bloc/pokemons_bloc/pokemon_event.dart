part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonsEvent extends PokemonEvent {}

class LoadMorePokemonsEvent extends PokemonEvent {}

class LoadPreviousPokemonsEvent extends PokemonEvent {}

class SaveScrollPositionEvent extends PokemonEvent {
  final String pokemonName;

  const SaveScrollPositionEvent({ required this.pokemonName});

  @override
  List<Object> get props => [pokemonName];
}

class SearchPokemonEvent extends PokemonEvent {
  final String query;

  const SearchPokemonEvent(this.query);

  @override
  List<Object> get props => [query];
}