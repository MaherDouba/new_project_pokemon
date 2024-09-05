import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error/exceptions.dart';
import '../../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  Future<List<PokemonModel>> getCachedPokemons(int page);
  Future<void> cachePokemons(List<PokemonModel> pokemons, int page, double scrollPosition);
  Future<void> saveScrollPosition(double position);
  Future<double?> getScrollPosition();
  Future<void> saveCurrentPage(int page);
  Future<int> getCurrentPage();
  Future<List<int>> getCachedPages();
  Future<int> getNextCachedPage(int currentPage); 
}

const CACHED_POKEMONS = 'CACHED_POKEMONS_PAGE_';
const String SCROLL_POSITION_KEY = 'SCROLL_POSITION_KEY_';
const String CURRENT_PAGE_KEY = 'CURRENT_PAGE_KEY';
const String CACHED_PAGES_KEY = 'CACHED_PAGES_KEY';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PokemonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cachePokemons(List<PokemonModel> pokemonModel, int page, double scrollPosition) async {
    await saveScrollPosition(scrollPosition);
    List pokemonModelToList = pokemonModel.map<Map<String, dynamic>>((pokemonModel) => pokemonModel.toJson()).toList();
    await sharedPreferences.setString('$CACHED_POKEMONS$page', json.encode(pokemonModelToList));
    
  
    List<int> cachedPages = await getCachedPages();
    if (!cachedPages.contains(page)) {
      cachedPages.add(page);
      await sharedPreferences.setString(CACHED_PAGES_KEY, json.encode(cachedPages));
    }
    
    print("pokimonons were stored for the page $page");
    return Future.value(null);
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
  Future<void> saveScrollPosition(double position) async {
    int currentPage = await getCurrentPage();
    await sharedPreferences.setDouble('$SCROLL_POSITION_KEY$currentPage', position);
  }

  @override
  Future<double?> getScrollPosition() async {
    int currentPage = await getCurrentPage();
    return sharedPreferences.getDouble('$SCROLL_POSITION_KEY$currentPage');
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
}
