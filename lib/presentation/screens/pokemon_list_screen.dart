import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/service_locator.dart';
import '../../domain/usecases/get_scroll_position.dart';
import '../../domain/usecases/save_scroll_position.dart';
import '../bloc/pokemon_bloc.dart';
import '../widgets/pokemon_error_widget.dart';
import '../widgets/shimmer_post.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

 @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(_onScroll);

    // Save scroll position on dispose
    _scrollController.addListener(() {
      sl<SaveScrollPosition>().call(_scrollController.position.pixels);
    });
    
    // Restore the scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final savedPosition = await sl<GetScrollPosition>().call();
      if (savedPosition != null  && savedPosition > 0.0) {
        _scrollController.jumpTo(savedPosition);
      }
    });
    print("Restored the scroll position");
    context.read<PokemonBloc>().add(GetPokemonsEvent());
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      final state = context.read<PokemonBloc>().state;
      if (state is PokemonLoaded && !state.hasReachedMax) {
        setState(() {
          isLoadingMore = true;
        });
        context.read<PokemonBloc>().add(LoadMorePokemonsEvent());
      }
    }
  }

  @override
  void dispose() {
    // Save scroll location
    sl<SaveScrollPosition>().call(_scrollController.position.pixels);
   _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemons'),
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: 20,
              itemBuilder: (context, index) => ShimmerPostWidget(),
            );
          } else if (state is PokemonLoaded) {
            // Reset isLoadingMore after the state changes
            isLoadingMore = false;
            return LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = screenWidth < 600 ? 2 : 4;
                final childAspectRatio = screenWidth < 600 ? 3 / 4 : 2 / 3;

                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: state.pokemons.length,
                    itemBuilder: (context, index) {
                      final pokemon = state.pokemons[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PokemonDetailPage(pokemon: pokemon),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: pokemon.imageUrl,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                                height: screenWidth < 600 ? 120 : 150,
                                width: screenWidth < 600 ? 120 : 150,
                              ),
                              SizedBox(height: 10),
                              Text(
                                pokemon.name,
                                style: TextStyle(
                                    fontSize: screenWidth < 600 ? 14 : 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is PokemonError) {
            return PokemonErrorWidget(message: state.message);
          } else {
            return Center(child: Text('Something went wrong.'));
          }
        },
      ),
    /*  floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PokemonBloc>().add(GetPokemonsEvent());
        },
        child: Icon(Icons.refresh),
      ), */
    );
  }
}
