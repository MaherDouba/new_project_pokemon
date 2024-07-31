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

/* factory Pokemon.fromJson(Map<String, dynamic> json) {
    final urlParts = json['url'].split('/');
    final id = urlParts[urlParts.length - 2];

    return Pokemon(
      name: json['name'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
      url: json['url'],
      weight: json['weight']?.toInt() ?? 199,
      height: json['height']?.toInt() ??100 ,
      hp: json['hp']?.toInt() ?? 15,
      atk: json['atk']?.toInt()?? 90,
      def: json['def']?.toInt() ?? 45,
      spd: json['spd']?.toInt() ?? 13,
      exp: json['exp']?.toInt() ?? 20,
    );
  }*/
@override
  List<Object?> get props => [name, imageUrl, url, weight, height,hp,atk,def,spd,exp];

}