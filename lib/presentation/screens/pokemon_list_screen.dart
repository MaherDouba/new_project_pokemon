import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pokemon_bloc.dart';
import '../widgets/shimmer_post.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemons'),
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonInitial) {
            return const Center(child: Text('Welcome'));
          } else if (state is PokemonLoading) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => ShimmerPostWidget(),
            );
          } else if (state is PokemonLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
              ),
              itemCount: state.pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = state.pokemons[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailPage(pokemon: pokemon),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(pokemon.imageUrl, height: 100, width: 100),
                        SizedBox(height: 10),
                        Text(
                          pokemon.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is PokemonError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Unknown State'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PokemonBloc>().add(GetPokemonsEvent());
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
