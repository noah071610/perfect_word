// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordCardModelAdapter extends TypeAdapter<WordCardModel> {
  @override
  final int typeId = 2;

  @override
  WordCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordCardModel(
      key: fields[0] as String,
      word: fields[1] as String,
      meaning: fields[2] as String,
      pronounce: fields[3] as String,
      format: fields[4] as CardFormat,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WordCardModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.meaning)
      ..writeByte(3)
      ..write(obj.pronounce)
      ..writeByte(4)
      ..write(obj.format)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardFormatAdapter extends TypeAdapter<CardFormat> {
  @override
  final int typeId = 3;

  @override
  CardFormat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardFormat.unchecked;
      case 1:
        return CardFormat.memorized;
      case 2:
        return CardFormat.difficulty;
      default:
        return CardFormat.unchecked;
    }
  }

  @override
  void write(BinaryWriter writer, CardFormat obj) {
    switch (obj) {
      case CardFormat.unchecked:
        writer.writeByte(0);
        break;
      case CardFormat.memorized:
        writer.writeByte(1);
        break;
      case CardFormat.difficulty:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardFormatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordCardModel _$WordCardModelFromJson(Map<String, dynamic> json) =>
    WordCardModel(
      key: json['key'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      pronounce: json['pronounce'] as String,
      format: $enumDecode(_$CardFormatEnumMap, json['format']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WordCardModelToJson(WordCardModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'word': instance.word,
      'meaning': instance.meaning,
      'pronounce': instance.pronounce,
      'format': _$CardFormatEnumMap[instance.format]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$CardFormatEnumMap = {
  CardFormat.unchecked: 'unchecked',
  CardFormat.memorized: 'memorized',
  CardFormat.difficulty: 'difficulty',
};
