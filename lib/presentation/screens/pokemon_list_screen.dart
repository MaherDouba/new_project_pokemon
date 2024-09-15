import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/scroll_helper/visibility_detector.dart';
import '../../domain/entities/pokemon.dart';
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
  bool isLoadingPrevious = false;
  
  @override
  void initState() {
    super.initState();
   
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("initState ...... addPostFrameCallback");
      await _restoreScrollPosition();
    });
     context.read<PokemonBloc>().add(GetPokemonsEvent());
  }

Future<void> _restoreScrollPosition() async {
  final state = context.read<PokemonBloc>().state;
  if (state is PokemonLoaded && state.scrollPokemonName != null) {
    final index = state.pokemons.indexWhere((pokemon) => pokemon.name == state.scrollPokemonName);
    print("index = $index");
    if (index != -1) {
      await Future.delayed(Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        final itemHeight = MediaQuery.of(context).size.width / 2;
        final offset = index * itemHeight;
        _scrollController.jumpTo(offset);
      }
    }
  }
}

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    print("currentscroll = $currentScroll");
    if (currentScroll == maxScroll && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      context.read<PokemonBloc>().add(LoadMorePokemonsEvent());
    } else if (currentScroll <100 && !isLoadingPrevious ) {
      setState(() {
        isLoadingPrevious = true;
      });
      context.read<PokemonBloc>().add(LoadPreviousPokemonsEvent());
    }

    _saveScrollPosition();
  }

  void _saveScrollPosition() {
    if (_scrollController.hasClients) {
      final state = context.read<PokemonBloc>().state;
      if (state is PokemonLoaded) {
        final itemHeight = MediaQuery.of(context).size.width / 2;
        final firstVisibleItemIndex = (_scrollController.offset / itemHeight).round();
        if (firstVisibleItemIndex >= 0 && firstVisibleItemIndex < state.pokemons.length) {
          final pokemonName = state.pokemons[firstVisibleItemIndex].name;
          context.read<PokemonBloc>().add(SaveScrollPositionEvent(
            page: state.currentPage,
            pokemonName: pokemonName,
          ));
          print("page ${state.currentPage}");
          print("pokemonName..= $pokemonName");
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemons'),
      ),
      body: BlocConsumer<PokemonBloc, PokemonState>(
        listener: (context, state) {
          if (state is PokemonLoaded) {
            setState(() {
              isLoadingMore = false;
              isLoadingPrevious = false;
            });
              WidgetsBinding.instance.addPostFrameCallback((_) {
              _restoreScrollPosition();
            });
          }
        },
        builder: (context, state) {
          if (state is PokemonLoading) {
            return ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => ShimmerPostWidget(),
            );
          } else if (state is PokemonLoaded) {
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
                    itemCount: state.hasReachedMax
                        ? state.pokemons.length
                        : state.pokemons.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.pokemons.length) {
                        final pokemon = state.pokemons[index];
                        return VisibilityDetector(
                            key: Key(pokemon.name),
                            onVisibilityChanged: (VisibilityInfo info) {
                              debugPrint("${info.key.toString().split("[<'")[1].split("'>]")[0]} of my widget is visible");
                            },
                          child: _buildPokemonCard(pokemon, screenWidth)
                        );
                      } else {
                        return const Center(            
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
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
    );
  }

  Widget _buildPokemonCard(Pokemon pokemon, double screenWidth) {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: pokemon.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
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
  }
}



/*

Future<void> _restoreScrollPosition() async {
  final state = context.read<PokemonBloc>().state;
  if (state is PokemonLoaded && state.scrollPokemonName != null) {
    final index = state.pokemons.indexWhere((pokemon) => pokemon.name == state.scrollPokemonName);
    print("Restoring scroll position, index = $index");
    if (index != -1) {
      await Future.delayed(Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        final size = MediaQuery.of(context).size;
        final itemWidth = size.width / 2;
        final itemHeight = itemWidth; // افتراض أن العنصر مربع
        final itemsPerRow = 2;

        final rowIndex = index ~/ itemsPerRow;
        final offset = rowIndex * itemHeight;

        final viewportHeight = _scrollController.position.viewportDimension;
        final middleOffset = math.max(0, offset - (viewportHeight / 2) + (itemHeight / 2));

        _scrollController.animateTo(
          middleOffset.toDouble(),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        print("Restored scroll position to pokemon: ${state.scrollPokemonName} at index $index");
      }
    }
  }
}

void _saveScrollPosition() {
  if (_scrollController.hasClients) {
    final state = context.read<PokemonBloc>().state;
    if (state is PokemonLoaded) {
      final viewportHeight = _scrollController.position.viewportDimension;
      final firstVisibleItemOffset = _scrollController.offset;
      
      final size = MediaQuery.of(context).size;
      final itemWidth = size.width / 2;
      final itemHeight = itemWidth; // افتراض أن العنصر مربع
      final itemsPerRow = 2;
      
      final firstVisibleRowIndex = (firstVisibleItemOffset / itemHeight).floor();
      final firstVisibleItemIndex = firstVisibleRowIndex * itemsPerRow;
      
      final visibleItemsCount = (viewportHeight / itemHeight).ceil() * itemsPerRow;
      final lastVisibleItemIndex = math.min(
        firstVisibleItemIndex + visibleItemsCount - 1,
        state.pokemons.length - 1
      );
      
      final middleItemIndex = ((firstVisibleItemIndex + lastVisibleItemIndex) / 2).round();
      
      if (middleItemIndex >= 0 && middleItemIndex < state.pokemons.length) {
        final pokemonName = state.pokemons[middleItemIndex].name;
        context.read<PokemonBloc>().add(SaveScrollPositionEvent(
          page: state.currentPage,
          pokemonName: pokemonName,
        ));
        
        print("Saved scroll position: page ${state.currentPage}, pokemonName = $pokemonName, index = $middleItemIndex");
      }
    }
  }
}

 */