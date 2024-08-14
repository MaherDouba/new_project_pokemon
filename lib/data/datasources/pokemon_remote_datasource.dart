import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/data/models/pokemon_model.dart';


abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getAllPokemons();
}

const BASE_URL = 'https://pokeapi.co/api/v2/pokemon?limit=100';

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;
  
  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PokemonModel>> getAllPokemons() async {

    try {
  final response = await client.get(
    Uri.parse(BASE_URL),
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