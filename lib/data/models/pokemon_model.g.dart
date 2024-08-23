// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonModelAdapter extends TypeAdapter<PokemonModel> {
  @override
  final int typeId = 0;

  @override
  PokemonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonModel(
      name: fields[0] as String,
      imageUrl: fields[1] as String,
      url: fields[2] as String,
      weight: fields[3] as int,
      height: fields[4] as int,
      hp: fields[5] as int,
      atk: fields[6] as int,
      def: fields[7] as int,
      spd: fields[8] as int,
      exp: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.hp)
      ..writeByte(6)
      ..write(obj.atk)
      ..writeByte(7)
      ..write(obj.def)
      ..writeByte(8)
      ..write(obj.spd)
      ..writeByte(9)
      ..write(obj.exp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
