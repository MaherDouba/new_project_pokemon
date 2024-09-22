import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error/exceptions.dart';
import '../../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  Future<List<PokemonModel>> getCachedPokemons(int page);
  Future<void> cachePokemons(List<PokemonModel> pokemons, int page);

  Future<void> saveScrollPosition( String pokemonName);
  Future<String?> getScrollPosition();

  Future<void> saveCurrentPage(int page);
  Future<int> getCurrentPage();
  
  Future<List<int>> getCachedPages();
  Future<int> getNextCachedPage(int currentPage);

  Future<void> saveAllPokemonNames(List<String> names);
  Future<List<String>> getAllPokemonNames();
}
const String ALL_POKEMON_NAMES = "ALL_POKEMON_NAMES";

const CACHED_POKEMONS = 'CACHED_POKEMONS_PAGE_';
const String SCROLL_POSITION_KEY = 'SCROLL_POSITION_KEY_';
const String CURRENT_PAGE_KEY = 'CURRENT_PAGE_KEY';
const String CACHED_PAGES_KEY = 'CACHED_PAGES_KEY';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PokemonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cachePokemons(List<PokemonModel> pokemonModel, int page) async {
    List pokemonModelToList = pokemonModel.map<Map<String, dynamic>>((pokemonModel) => pokemonModel.toJson()).toList();
    await sharedPreferences.setString('$CACHED_POKEMONS$page', json.encode(pokemonModelToList));
    
    List<int> cachedPages = await getCachedPages();
    if (!cachedPages.contains(page)) {
      cachedPages.add(page);
      await sharedPreferences.setString(CACHED_PAGES_KEY, json.encode(cachedPages));
    }
    
    print("pokimonons were stored for the page $page");
  }

  @override
  Future<List<PokemonModel>> getCachedPokemons(int page) async {
    final jsonString = sharedPreferences.getString('$CACHED_POKEMONS$page');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      List<PokemonModel> jsonToPokemonModels = jsonList.map<PokemonModel>((jsonPokemonModel) => PokemonModel.fromJson(jsonPokemonModel)).toList();
      return Future.value(jsonToPokemonModels);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<void> saveScrollPosition(String pokemonName) async {
    await sharedPreferences.setString('$SCROLL_POSITION_KEY', pokemonName);
    
  }

  @override
  Future<String?> getScrollPosition() async {
    return sharedPreferences.getString('$SCROLL_POSITION_KEY');
  }

  @override
  Future<void> saveCurrentPage(int page) async {
    await sharedPreferences.setInt(CURRENT_PAGE_KEY, page);
  }

  @override
  Future<int> getCurrentPage() async {
    return sharedPreferences.getInt(CURRENT_PAGE_KEY) ?? 1;
  }

  @override
  Future<List<int>> getCachedPages() async {
    final String? cachedPagesString = sharedPreferences.getString(CACHED_PAGES_KEY);
    if (cachedPagesString != null) {
      List<dynamic> cachedPagesList = json.decode(cachedPagesString);
      return cachedPagesList.cast<int>()..sort();
    }
    return [];
  }

  @override
  Future<int> getNextCachedPage(int currentPage) async {
    List<int> cachedPages = await getCachedPages();
    if (cachedPages.isEmpty) {
      throw EmptyCacheException();
    }
    int index = cachedPages.indexOf(currentPage);
    if (index == -1 || index == cachedPages.length - 1) {
      return cachedPages.first;
    } else {
      return cachedPages[index + 1];
    }
  }

  @override
  Future<void> saveAllPokemonNames(List<String> names) async {
    await sharedPreferences.setStringList(ALL_POKEMON_NAMES, names);
  }

  @override
  Future<List<String>> getAllPokemonNames() async {
    return sharedPreferences.getStringList(ALL_POKEMON_NAMES) ?? [];
  }



}
