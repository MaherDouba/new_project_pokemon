import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/routes/app_router.dart';
import 'core/services/service_locator.dart' as di;
import 'presentation/bloc/language_bloc/language_state.dart';
import 'presentation/bloc/language_bloc/languge_bloc.dart';
import 'presentation/bloc/pokemons_bloc/pokemon_bloc.dart';
import 'presentation/bloc/theme_bloce/theme_bloc.dart';
import 'presentation/bloc/theme_bloce/theme_event.dart';
import 'presentation/bloc/theme_bloce/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<PokemonBloc>()),
        BlocProvider(
          create: (context) {
            final themeBloc = di.sl<ThemeBloc>();
            themeBloc.add(GetThemeEvent());
            return themeBloc;
          },
        ),
        BlocProvider(create: (context) => di.sl<LanguageBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Pokemon App',
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: themeState is ThemeLoaded && themeState.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: languageState is LanguageLoaded
                    ? Locale(languageState.languageCode)
                    : context.locale,
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: '/',
              );
            },
          );
        },
      ),
    );
  }
}
