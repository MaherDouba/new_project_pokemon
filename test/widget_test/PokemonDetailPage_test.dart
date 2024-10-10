import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:untitled/domain/entities/pokemon.dart';
import 'package:untitled/presentation/screens/pokemon_detail_screen.dart';

void main() {
  testWidgets('PokemonDetailPage displays correct information', (WidgetTester tester) async {
    // Create a mock Pokemon object
    const mockPokemon = Pokemon(
      name: 'Pikachu',
      imageUrl: 'https://example.com/pikachu.png',
      weight: 6,
      height: 4,
      hp: 35,
      atk: 55,
      def: 40,
      spd: 90,
      exp: 112,
     url: 'url',
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home: PokemonDetailPage(pokemon: mockPokemon),
      ));
    });

    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('6 KG'), findsOneWidget);
    expect(find.text('4 M'), findsOneWidget);
    expect(find.text('HP:'), findsOneWidget);
    expect(find.text('35'), findsOneWidget);
    expect(find.text('ATK:'), findsOneWidget);
    expect(find.text('55'), findsOneWidget);
    expect(find.text('DEF:'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('SPD:'), findsOneWidget);
    expect(find.text('90'), findsOneWidget);
    expect(find.text('EXP:'), findsOneWidget);
    expect(find.text('112'), findsOneWidget);

    // Verify that the image is displayed (CachedNetworkImage widget)
    expect(find.byType(CachedNetworkImage), findsOneWidget);

    // Verify that LinearProgressIndicator widgets are present for stats
    expect(find.byType(LinearProgressIndicator), findsNWidgets(5));
  });

  testWidgets('PokemonDetailPage adapts to different screen sizes', (WidgetTester tester) async {
    final mockPokemon = Pokemon(
      name: 'Bulbasaur',
      imageUrl: 'https://example.com/bulbasaur.png',
      weight: 6,
      height: 7,
      hp: 45,
      atk: 49,
      def: 49,
      spd: 45,
      exp: 64,
     url: 'url',
    );

    // Test vertical layout
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: PokemonDetailPage(pokemon: mockPokemon),
        ),
      ));
    });

    expect(find.byType(Column), findsWidgets);
    expect(find.byType(Row), findsWidgets);

    // Test horizontal layout
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 400)),
          child: PokemonDetailPage(pokemon: mockPokemon),
        ),
      ));
    });

    expect(find.byType(Row), findsWidgets);
  });
}
