import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  Future<List<PokemonModel>> getCachedPokemons();
  Future<void> cachePokemons(List<PokemonModel> pokemons);
  Future<void> saveScrollPosition(double position);
  Future<double?> getScrollPosition();
}

const CACHED_POKEMONS = 'CACHED_LIST_POKEMONS';
const String SCROLL_POSITION_KEY = 'SCROLL_POSITION_KEY';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PokemonLocalDataSourceImpl({required this.sharedPreferences});


  @override
  Future<void> cachePokemons(List<PokemonModel> pokemonModel) {
    List PokemonModelToList = pokemonModel.map<Map<String,dynamic>>((pokemonModel) => pokemonModel.toJson()).toList();
    sharedPreferences.setString(CACHED_POKEMONS, json.encode(PokemonModelToList));
    print("from cach pokemon / pokemon_local_datasource");
     return Future.value(unit);
  }

  @override
  Future<List<PokemonModel>> getCachedPokemons() async {
    
    final jsonString = sharedPreferences.getString(CACHED_POKEMONS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      List<PokemonModel> jsonToPokemonModels = jsonList.map<PokemonModel>((jsonPokemonModel) => PokemonModel.fromJson(jsonPokemonModel)).toList();
      print("from pokemon_local_datasource / getcachedpokemon");
      return Future.value(jsonToPokemonModels);
    } else {
      throw EmptyCacheException();
    }
  }


  @override
  Future<void> saveScrollPosition(double position) async {
    await sharedPreferences.setDouble(SCROLL_POSITION_KEY, position);
  }

  @override
  Future<double?> getScrollPosition() async {
    return sharedPreferences.getDouble(SCROLL_POSITION_KEY);
  }

  
}
