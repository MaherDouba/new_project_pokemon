import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();
  
  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final String languageCode;

  const LanguageLoaded(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
