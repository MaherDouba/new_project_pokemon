import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/usecases_theme/get_current_theme.dart';
import '../../../domain/usecases/usecases_theme/save_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetCurrentTheme getCurrentTheme;
  final SaveTheme saveTheme;

  ThemeBloc({required this.getCurrentTheme, required this.saveTheme}) : super(ThemeInitial()) {
    on<GetThemeEvent>(_onGetThemeEvent);
    on<ChangeThemeEvent>(_onChangeThemeEvent);
  }

  void _onGetThemeEvent(GetThemeEvent event, Emitter<ThemeState> emit) async {
    final isDarkMode = await getCurrentTheme();
    emit(ThemeLoaded(isDarkMode));
  }

  void _onChangeThemeEvent(ChangeThemeEvent event, Emitter<ThemeState> emit) async {
    await saveTheme(event.isDarkMode);
    emit(ThemeLoaded(event.isDarkMode));
  }
}
