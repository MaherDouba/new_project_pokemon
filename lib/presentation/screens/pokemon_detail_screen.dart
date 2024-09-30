import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailPage({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool useVerticalLayout = screenSize.width < screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name, textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: useVerticalLayout ? _buildVerticalLayout() : _buildHorizontalLayout(),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        _buildImageCard(),
        const SizedBox(height: 16),
        _buildInfoSection(),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildImageCard()),
        const SizedBox(width: 16),
        Expanded(child: _buildInfoSection()),
      ],
    );
  }

  Widget _buildImageCard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Hero(
        tag: 'pokemon_image_${pokemon.imageUrl}',
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: CachedNetworkImage(
            imageUrl: pokemon.imageUrl,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error, size: 100),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWeightHeightRow(),
        const SizedBox(height: 16),
        _buildStatRow('HP', pokemon.hp),
        _buildStatRow('ATK', pokemon.atk),
        _buildStatRow('DEF', pokemon.def),
        _buildStatRow('SPD', pokemon.spd),
        _buildStatRow('EXP', pokemon.exp),
      ],
    );
  }

  Widget _buildWeightHeightRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoCard('Weight', '${pokemon.weight} KG'),
        _buildInfoCard('Height', '${pokemon.height} M'),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatRow(String label, int value) {
    Color _color = Colors.black;
    if (value < 25) {
      _color = Colors.red;
    } else if (value < 60) {
      _color = Colors.blue;
    } else if (value <= 100) {
      _color = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
              width: 50,
              child: Text('$label:',  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              
          const SizedBox(width: 10),
          Text('$value', style: TextStyle(fontSize: 18, color: _color)),
          const SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(5),
              value: value / 100.0,
              backgroundColor: Colors.grey[300],
              color: _color,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}
