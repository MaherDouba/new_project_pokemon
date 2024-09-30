import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/pokemon.dart';
import '../../core/animations/fade_in_animation.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const PokemonCard({
    Key? key,
    required this.pokemon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'pokemon_image_${pokemon.imageUrl}',
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width < 600 ? 120 : 150,
                  width: MediaQuery.of(context).size.width < 600 ? 120 : 150,
                ),
              ),
              SizedBox(height: 10),
              Text(
                pokemon.name,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
