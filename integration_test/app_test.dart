import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:untitled/main.dart' as app;
import 'package:untitled/presentation/screens/pokemon_list_screen.dart';
import 'package:untitled/presentation/screens/pokemon_detail_screen.dart';
import 'package:untitled/presentation/widgets/pokemon_card.dart';
import 'package:untitled/presentation/widgets/app_drawer.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Test main app ', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

// Verify that PokemonListScreen is the initial route
      await tester.pump();
      expect(find.byType(PokemonListScreen), findsOneWidget);

      // Wait for the Pokemon list to load
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Verify that PokemonCards are displayed
      await tester.pump();
      expect(find.byType(PokemonCard), findsWidgets);

      // Tap on the first PokemonCard
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PokemonCard).first);
      await tester.pump();

      // Verify that PokemonDetailPage is displayed
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byType(PokemonDetailPage), findsOneWidget);

      // Go back to PokemonListScreen
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));  

// Test search functionality
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Bulbasaur');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Verify search results
      expect(find.text('Bulbasaur'), findsOneWidget);

// closse search
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();


// Open the drawer
      await tester.pumpAndSettle();
      final Finder menuIconButton = find.byIcon(Icons.menu);
      expect(menuIconButton, findsOneWidget);
      await tester.tap(menuIconButton);

      // Verify that the AppDrawer is displayed
      await tester.pumpAndSettle();
      expect(find.byKey(Key("Drawer")), findsOneWidget);

      // Test theme switching
      await tester.pumpAndSettle();
      final ThemeSwitchFinder = find.byKey(Key("Switch"));
      await tester.tap(ThemeSwitchFinder);
      await tester.pumpAndSettle();

      // Test language switching
      final LanguageDropdownFinder = find.byType(DropdownButton<String>);
      await tester.tap(LanguageDropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

// Close the drawer
      Navigator.of(tester.element(find.byType(Scaffold))).pop();
      await tester.pumpAndSettle(Duration(seconds: 5));



      // Test infinite scrolling
      final initialOffset = tester.getTopLeft(find.byType(PokemonCard).last).dy;
      await tester.dragFrom(
        tester.getCenter(find.byType(PokemonListScreen)),
        Offset(0, -500),
      );
      await tester.pumpAndSettle();
      final newOffset = tester.getTopLeft(find.byType(PokemonCard).last).dy;
      expect(newOffset, lessThan(initialOffset));
    });
  });
}
