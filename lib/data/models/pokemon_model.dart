
import 'package:hive/hive.dart';
import '../../domain/entities/pokemon.dart';
part 'pokemon_model.g.dart';

@HiveType(typeId: 0)
class PokemonModel extends Pokemon {

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final int weight;

  @HiveField(4)
  final int height;

  @HiveField(5)
  final int hp;

  @HiveField(6)
  final int atk;

  @HiveField(7)
  final int def;

  @HiveField(8)
  final int spd;

  @HiveField(9)
  final int exp;

  PokemonModel({
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
  }) : super(
          name: name,
          imageUrl: imageUrl,
          url: url,
          weight: weight,
          height: height,
          hp: hp,
          atk: atk,
          def: def,
          spd: spd,
          exp: exp,
        );

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final String url = json['url'];
    final String imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${url.split('/')[6]}.png';
    return PokemonModel(
      name: json['name'],
      imageUrl: imageUrl,
      url: url,
      weight: json['weight']?.toInt() ?? 170,
      height: json['height']?.toInt() ??193 ,
      hp: json['hp']?.toInt() ?? 19,
      atk: json['atk']?.toInt()?? 42,
      def: json['def']?.toInt() ?? 65,
      spd: json['spd']?.toInt() ?? 93,
      exp: json['exp']?.toInt() ?? 18,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'url': url,
      'weight': weight,
      'height': height,
      'hp': hp,
      'atk': atk,
      'def': def,
      'spd': spd,
      'exp': exp,
    };
  }
}
