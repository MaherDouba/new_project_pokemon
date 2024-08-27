import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/data/models/pokemon_model.dart';


abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getAllPokemons(int page);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;
   static const int limit = 50;
   late int offset;
   static const BASE_URL = 'https://pokeapi.co/api/v2/pokemon';
  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PokemonModel>> getAllPokemons(int page) async {
    
    offset = (page - 1) * limit;
    final url = '$BASE_URL?offset=$offset&limit=$limit';
    try {
  final response = await client.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );
  
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body)['results'];
    return jsonList.map((json) => PokemonModel.fromJson(json)).toList();
  } else {
    throw ServerException();
  }
} catch (e) {
  
      throw Exception('Failed to fetch pokemons: $e');
    } 

  }
}