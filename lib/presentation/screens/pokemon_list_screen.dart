import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/service_locator.dart';
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
  bool isLoadingPrevious = false;
  
  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(GetPokemonsEvent());
  _scrollController.addListener(_onScroll);
    // Restore the scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = context.read<PokemonBloc>().state;
      if (state is PokemonLoaded && state.scrollPercentage > 0.0) {
        await _restoreScrollPosition(state.scrollPercentage);
      }
    });
    
    // Save scroll percentage on scroll
     _scrollController.addListener(() {
      if (_scrollController.hasClients) {
         final state = context.read<PokemonBloc>().state;
         if (state is PokemonLoaded ) {
          
            double max = _scrollController.position.maxScrollExtent * (state.currentPage);
            print("maxScrollExtent =${_scrollController.position.maxScrollExtent} ");
            double scrollPercentage = _scrollController.offset / max ;
            print("current page  = ${state.currentPage}");
            print("offset =${_scrollController.offset} ");
            print("maxScroll =${max} ");
            print(" offset /maxScroll =${scrollPercentage} ");

        sl<SaveScrollPercentage>().call(scrollPercentage);
         }
      /*  double scrollPercentage = _scrollController.offset / _scrollController.position.maxScrollExtent;
        print(" _scrollController.offset =${_scrollController.offset} ");
        print(" _scrollController.position.maxScrollExtent =${_scrollController.position.maxScrollExtent} ");
        print(" offset /maxScrollExtent =${scrollPercentage} ");
        sl<SaveScrollPercentage>().call(scrollPercentage);*/
      }
    });
  }

  Future<void> _restoreScrollPosition(double scrollPercentage) async {
    await Future.delayed(Duration(milliseconds: 100)); 
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final scrollTo = maxScroll * scrollPercentage;
      print("scrollPercentage....$scrollPercentage");
      print("scrollTo .... $scrollTo");
      _scrollController.jumpTo(scrollTo);
    }
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    if (currentScroll == maxScroll && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      context.read<PokemonBloc>().add(LoadMorePokemonsEvent());
    } else if (currentScroll == 0 && !isLoadingPrevious) {
      setState(() {
        isLoadingPrevious = true;
      });
      context.read<PokemonBloc>().add(LoadPreviousPokemonsEvent());
    }
  }

  @override
  void dispose() {
    // Save scroll percentage on dispose
    if (_scrollController.hasClients) {
      double scrollPercentage = _scrollController.offset / _scrollController.position.maxScrollExtent;
      sl<SaveScrollPercentage>().call(scrollPercentage);
    }
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
           //   controller: _scrollController,
              itemCount: 20,
              itemBuilder: (context, index) => ShimmerPostWidget(),
            );
          } else if (state is PokemonLoaded ) {
            isLoadingPrevious = false;
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
                    itemCount: state.hasReachedMax
                        ? state.pokemons.length
                        : state.pokemons.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.pokemons.length) {
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
}






/*


   // final itemHeight = _scrollController.position.maxScrollExtent / state.pokemons.length;
  // max = max - itemHeight;

  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(GetPokemonsEvent());
    _scrollController.addListener(_onScroll);
    
    // Restore the scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = context.read<PokemonBloc>().state;
      if (state is PokemonLoaded && state.scrollPosition > 0.0) {
        await _restoreScrollPosition(state.scrollPosition);
      }
    });
    
    // Save scroll percentage on scroll
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        double scrollPercentage = _scrollController.offset / _scrollController.position.maxScrollExtent;
        sl<SaveScrollPosition>().call(scrollPercentage);
      }
    });
  }

Future<void> _restoreScrollPosition(double scrollPercentage) async {
  await Future.delayed(Duration(milliseconds: 100));
  if (_scrollController.hasClients) {
    final state = context.read<PokemonBloc>().state;
    if (state is PokemonLoaded) {
      final cachedCount = (state.currentPage-1 )*50 ;
      print("state.currentPage = ${state.currentPage}");
       print("cachedCount = $cachedCount");
      final itemHeight = 150.0;
      final totalItemsHeight = cachedCount * itemHeight;
      final visibleItemsHeight = _scrollController.position.viewportDimension;
      print("visibleItemsHeight = $visibleItemsHeight");
      final scrollableHeight = totalItemsHeight - visibleItemsHeight;
      
      if (scrollableHeight > 0) {
        final scrollTo = scrollableHeight * scrollPercentage;
        _scrollController.jumpTo(scrollTo);
      }
    }
  }
}

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    if (currentScroll == maxScroll && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      context.read<PokemonBloc>().add(LoadMorePokemonsEvent());
    } else if (currentScroll == 0 && !isLoadingPrevious) {
      setState(() {
        isLoadingPrevious = true;
      });
      context.read<PokemonBloc>().add(LoadPreviousPokemonsEvent());
    }
  }

  @override
  void dispose() {
    // Save scroll percentage on dispose
    if (_scrollController.hasClients) {
      double scrollPercentage = _scrollController.offset / _scrollController.position.maxScrollExtent;
      sl<SaveScrollPosition>().call(scrollPercentage);
    }
    _scrollController.dispose();
    super.dispose();
  }


 */