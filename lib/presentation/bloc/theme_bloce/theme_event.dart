import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class GetThemeEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final bool isDarkMode;

  const ChangeThemeEvent(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}
