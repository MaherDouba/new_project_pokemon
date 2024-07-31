import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailPage({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(pokemon.imageUrl, height: 200, width: 200),
            ),
            SizedBox(height: 16),
            Text('Weight: ${pokemon.weight}', style: TextStyle(fontSize: 18)),
            Text('Height: ${pokemon.height}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            _buildStatRow('HP', pokemon.hp),
            _buildStatRow('ATK', pokemon.atk),
            _buildStatRow('DEF', pokemon.def),
            _buildStatRow('SPD', pokemon.spd),
            _buildStatRow('EXP', pokemon.exp),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 75, child: Text('$label: ', style: TextStyle(fontSize: 18))),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100.0,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
          ),
          SizedBox(width: 10),
          Text('$value', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
