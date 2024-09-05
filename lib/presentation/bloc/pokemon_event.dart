 part of 'pokemon_bloc.dart';
 
abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonsEvent extends PokemonEvent {}

class LoadMorePokemonsEvent extends PokemonEvent {}

class LoadPreviousPokemonsEvent extends PokemonEvent {}
