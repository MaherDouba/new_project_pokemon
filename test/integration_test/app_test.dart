import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:untitled/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('اختبارات التكامل للتطبيق', () {
    testWidgets('اختبار تحميل قائمة البوكيمون', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Pokemons'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);

      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('اختبار البحث عن بوكيمون', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();


      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Pikachu');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.text('Pikachu'), findsOneWidget);
    });

    /*testWidgets('اختبار تغيير الثيم', (WidgetTester tester) async {
      
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
    });*/
  });
}
