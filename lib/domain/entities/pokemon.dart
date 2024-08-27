import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final String name;
  final String imageUrl;
  final String url;
  final int weight;
  final int height;
  final int hp;
  final int atk;
  final int def;
  final int spd;
  final int exp;

  const Pokemon({
    required this.name,
    required this.imageUrl,
    required this.url,
    required this.weight,
    required this.height,
    required this.hp,
    required this.atk,
    required this.def,
    required this.spd,
    required this.exp,
  });

@override
  List<Object?> get props => [name, imageUrl, url, weight, height,hp,atk,def,spd,exp];

}