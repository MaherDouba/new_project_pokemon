import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/pokemon.dart';
import '../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  Future<List<Pokemon>> getCachedPokemons();
  Future<void> cachePokemons(List<Pokemon> pokemons);
}
 // ignore: constant_identifier_names
  String CACHED_POKEMONS = 'CACHED_POKEMONS';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  

  PokemonLocalDataSourceImpl({required this.sharedPreferences, required Object client});

  @override
  Future<List<Pokemon>> getCachedPokemons() {
    final jsonString = sharedPreferences.getString(CACHED_POKEMONS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map<PokemonModel>((json) => PokemonModel.fromJson(json)).toList());
    } else {
        throw EmptyCacheException();
    }
  }

  @override
  Future<void> cachePokemons(List<Pokemon> pokemons) {
    final List<Map<String, dynamic>> jsonList = pokemons.map((pokemon) => (pokemon as PokemonModel).toJson()).toList();
    return sharedPreferences.setString(CACHED_POKEMONS, json.encode(jsonList));
  }
}
