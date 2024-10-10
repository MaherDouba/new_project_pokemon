import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:untitled/presentation/bloc/language_bloc/language_event.dart';
import 'package:untitled/presentation/bloc/language_bloc/language_state.dart';
import 'package:untitled/presentation/bloc/language_bloc/languge_bloc.dart';
import 'package:untitled/presentation/bloc/theme_bloce/theme_bloc.dart';
import 'package:untitled/presentation/bloc/theme_bloce/theme_event.dart';
import 'package:untitled/presentation/bloc/theme_bloce/theme_state.dart';
import 'package:untitled/presentation/widgets/app_drawer.dart';


class MockThemeBloc extends Mock implements ThemeBloc {}
class MockLanguageBloc extends Mock implements LanguageBloc {}

void main() {
  late MockThemeBloc mockThemeBloc;
  late MockLanguageBloc mockLanguageBloc;

  setUp(() {
    mockThemeBloc = MockThemeBloc();
    mockLanguageBloc = MockLanguageBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>.value(value: mockThemeBloc),
          BlocProvider<LanguageBloc>.value(value: mockLanguageBloc),
        ],
        child: Scaffold(
          body: AppDrawer(),
        ),
      ),
    );
  }

  testWidgets('AppDrawer displays correct elements', (WidgetTester tester) async {
    when(() => mockThemeBloc.state).thenReturn(ThemeLoaded(false));
    when(() => mockLanguageBloc.state).thenReturn(LanguageLoaded('en'));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(DrawerHeader), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_outlined), findsOneWidget);
    expect(find.text('settings'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.text('dark_mode'), findsOneWidget);
    expect(find.byIcon(Icons.brightness_4), findsOneWidget);
    expect(find.text('Change_Language'), findsOneWidget);
    expect(find.byIcon(Icons.language), findsOneWidget);
  });

  testWidgets('Dark mode switch changes state', (WidgetTester tester) async {
    when(() => mockThemeBloc.state).thenReturn(ThemeLoaded(false));
    when(() => mockLanguageBloc.state).thenReturn(LanguageLoaded('en'));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(Switch));
    await tester.pump();

    verify(() => mockThemeBloc.add(any(that: isA<ChangeThemeEvent>()))).called(1);
  });

  testWidgets('Language dropdown changes state', (WidgetTester tester) async {
    when(() => mockThemeBloc.state).thenReturn(ThemeLoaded(false));
    when(() => mockLanguageBloc.state).thenReturn(LanguageLoaded('en'));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(DropdownButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    verify(() => mockLanguageBloc.add(any(that: isA<ChangeLanguageEvent>()))).called(1);
  });
}
