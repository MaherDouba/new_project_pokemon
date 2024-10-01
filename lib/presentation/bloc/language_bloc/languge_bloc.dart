import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/usecases_language/get_current_language.dart';
import '../../../domain/usecases/usecases_language/save_language.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final GetCurrentLanguage getCurrentLanguage;
  final SaveLanguage saveLanguage;

  LanguageBloc({required this.getCurrentLanguage, required this.saveLanguage}) : super(LanguageInitial()) {
    on<GetLanguageEvent>(_onGetLanguageEvent);
    on<ChangeLanguageEvent>(_onChangeLanguageEvent);
  }

  void _onGetLanguageEvent(GetLanguageEvent event, Emitter<LanguageState> emit) async {
    final language = await getCurrentLanguage();
    emit(LanguageLoaded(language));
  }

  void _onChangeLanguageEvent(ChangeLanguageEvent event, Emitter<LanguageState> emit) async {
    await saveLanguage(event.languageCode);
    emit(LanguageLoaded(event.languageCode));
  }
}
