import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/data/models/pokemon_model.dart';
import 'package:untitled/presentation/bloc/pokemons_bloc/pokemon_bloc.dart';
import 'package:untitled/presentation/bloc/theme_bloce/theme_bloc.dart';
import 'package:untitled/presentation/bloc/theme_bloce/theme_event.dart';
import 'package:untitled/presentation/bloc/theme_bloce/theme_state.dart';
import 'package:untitled/presentation/screens/pokemon_detail_screen.dart';
import 'package:untitled/presentation/screens/pokemon_list_screen.dart';
import 'package:untitled/presentation/widgets/pokemon_card.dart';
import 'package:untitled/presentation/widgets/pokemon_error_widget.dart';
import 'package:untitled/presentation/widgets/shimmer_post.dart';

class MockPokemonBloc extends MockBloc<PokemonEvent, PokemonState>  implements PokemonBloc {}
class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>  implements ThemeBloc {}


void main() {
  late MockPokemonBloc mockPokemonBloc;
  setUp(() {
    mockPokemonBloc = MockPokemonBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<PokemonBloc>.value(
        value: mockPokemonBloc,
        child: PokemonListScreen(),
      ),
    );
  }

  testWidgets('PokemonListScreen displays AppBar with search icon',
      (WidgetTester tester) async {
    whenListen(
      mockPokemonBloc,
      Stream.fromIterable([PokemonLoaded(pokemons: [], currentPage: 1)]),
      initialState: PokemonInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Pokemons'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

testWidgets('PokemonListScreen displays search field when search icon is tapped',
 (WidgetTester tester) async {
  whenListen(
    mockPokemonBloc,
    Stream.fromIterable([PokemonLoaded(pokemons: [], currentPage: 1)]),
    initialState: PokemonInitial(),
  );

  await tester.pumpWidget(createWidgetUnderTest());

  await tester.tap(find.byIcon(Icons.search));
  await tester.pump();

  expect(find.byType(TextField), findsOneWidget);
  
  final Finder textFinder = find.byType(Text);
  final List<String> actualTexts = tester.widgetList<Text>(textFinder).map((widget) => widget.data ?? '').toList();
  
  expect(actualTexts, contains('Search_Pokemon'), reason: 'Expected to find "Search_Pokemon", but found: $actualTexts');
});

  testWidgets('PokemonListScreen displays pokemon cards',
      (WidgetTester tester) async {
    final pokemons = [
      PokemonModel(
          name: 'Pikachu',
          imageUrl: 'url1',
          url: 'url',
          weight: 60,
          height: 40,
          hp: 35,
          atk: 55,
          def: 40,
          spd: 90,
          exp: 112),
      PokemonModel(
          name: 'Charizard',
          imageUrl: 'url2',
          url: 'url',
          weight: 905,
          height: 170,
          hp: 78,
          atk: 84,
          def: 78,
          spd: 100,
          exp: 240),
    ];

    whenListen(
      mockPokemonBloc,
      Stream.fromIterable([PokemonLoaded(pokemons: pokemons, currentPage: 1)]),
      initialState: PokemonInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    expect(find.byType(PokemonCard), findsNWidgets(2));
    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('Charizard'), findsOneWidget);
  });

testWidgets('Tapping a pokemon card navigates to detail screen',
    (WidgetTester tester) async {
  final pokemon = PokemonModel(
      name: 'PP',
      imageUrl: 'url1',
      url: 'url',
      weight: 60,
      height: 40,
      hp: 35,
      atk: 55,
      def: 40,
      spd: 90,
      exp: 112);
  
  whenListen(
    mockPokemonBloc,
    Stream.fromIterable([PokemonLoaded(pokemons: [pokemon], currentPage: 1)]),
    initialState: PokemonInitial(),
  );

  await tester.pumpWidget(createWidgetUnderTest());
  await tester.pump(); 
  
  print('Widgets found:');
  tester.allWidgets.forEach((widget) => print(widget.runtimeType));

  final pokemonCardFinder = find.byType(PokemonCard);
  expect(pokemonCardFinder, findsOneWidget, reason: 'PokemonCard not founddddddddddddddddddddddddd');

  await tester.tap(pokemonCardFinder);
  await tester.pump();

  print('Widgets after tap............................:');
  tester.allWidgets.forEach((widget) => print(widget.runtimeType));
  
  await tester.pump();
      
  expect(find.byType(PokemonDetailPage), findsWidgets, reason: 'PokemonDetailPage not found after tapping PokemonCard');
  expect(find.text('PP'), findsWidgets);
});

  testWidgets('PokemonListScreen displays loading state',
      (WidgetTester tester) async {
    whenListen(
      mockPokemonBloc,
      Stream.fromIterable([PokemonLoading()]),
      initialState: PokemonInitial(),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    expect(find.byType(ShimmerPostWidget), findsWidgets);
  });

  testWidgets('PokemonListScreen displays drawer when menu icon is tapped',
      (WidgetTester tester) async {
    whenListen(
      mockPokemonBloc,
      Stream.fromIterable([PokemonLoaded(pokemons: [], currentPage: 1)]),
      initialState: PokemonInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
 
    final DraweerFinder = find.byKey(Key("AppDrawer"));
    expect(DraweerFinder, findsOneWidget);

    await tester.tap(DraweerFinder);
  print('Widgets after tap:');
  tester.allWidgets.forEach((widget) => print(widget));
  });

  testWidgets('PokemonListScreen displays error state',
      (WidgetTester tester) async {
    whenListen(
      mockPokemonBloc,
      Stream.fromIterable([PokemonError(message: 'Error loading pokemons')]),
      initialState: PokemonInitial(),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    expect(find.byType(PokemonErrorWidget), findsOneWidget);
    expect(find.text('Error loading pokemons'), findsOneWidget);
  });
}
