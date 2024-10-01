import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/language_bloc/language_event.dart';
import '../bloc/language_bloc/language_state.dart';
import '../bloc/theme_bloce/theme_bloc.dart';
import '../bloc/language_bloc/languge_bloc.dart';
import '../bloc/theme_bloce/theme_event.dart';
import '../bloc/theme_bloce/theme_state.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.lightBlue],
              ),
            ),
            child: CircleAvatar(
              child: Icon(Icons.person_outline_outlined, size: 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                "Settings".toLowerCase().tr(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.settings),
            ),
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return ListTile(
                title: Text(
                  'dark_mode'.tr(),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.brightness_4),
                trailing: Switch(
                  value: state is ThemeLoaded ? state.isDarkMode : false,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(ChangeThemeEvent(value));
                  },
                ),
              );
            },
          ),
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return ListTile(
                title: Text(
                  'Change_Language'.tr(),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.language),
                trailing: DropdownButton<String>(
                  value: state is LanguageLoaded ? state.languageCode : 'en',
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<LanguageBloc>().add(ChangeLanguageEvent(newValue));
                      context.setLocale(Locale(newValue));
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
