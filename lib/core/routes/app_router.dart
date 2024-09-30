import 'package:flutter/material.dart';
import '../../presentation/screens/pokemon_list_screen.dart';
import '../../presentation/screens/pokemon_detail_screen.dart';
import '../../domain/entities/pokemon.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => PokemonListScreen());
      case '/detail':
        final pokemon = settings.arguments as Pokemon;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PokemonDetailPage(pokemon: pokemon),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.slowMiddle;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
