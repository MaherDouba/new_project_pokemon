import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/pokemon.dart';
//import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<Pokemon>> getAllPokemons();
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Pokemon>> getAllPokemons() async {
    final response = await client.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['results'];
      return jsonList.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pokemons');
    }
  }
}
