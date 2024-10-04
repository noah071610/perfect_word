// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_filter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordFilterModelAdapter extends TypeAdapter<WordFilterModel> {
  @override
  final int typeId = 4;

  @override
  WordFilterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordFilterModel(
      maskingType: fields[0] as CardMaskingType,
      layoutType: fields[1] as CardLayoutType,
      sortType: fields[2] as CardSortType,
    );
  }

  @override
  void write(BinaryWriter writer, WordFilterModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.maskingType)
      ..writeByte(1)
      ..write(obj.layoutType)
      ..writeByte(2)
      ..write(obj.sortType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordFilterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardSortTypeAdapter extends TypeAdapter<CardSortType> {
  @override
  final int typeId = 5;

  @override
  CardSortType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardSortType.createdAt;
      case 1:
        return CardSortType.oldestFirst;
      case 2:
        return CardSortType.alphabetical;
      case 3:
        return CardSortType.difficulty;
      case 4:
        return CardSortType.memorized;
      default:
        return CardSortType.createdAt;
    }
  }

  @override
  void write(BinaryWriter writer, CardSortType obj) {
    switch (obj) {
      case CardSortType.createdAt:
        writer.writeByte(0);
        break;
      case CardSortType.oldestFirst:
        writer.writeByte(1);
        break;
      case CardSortType.alphabetical:
        writer.writeByte(2);
        break;
      case CardSortType.difficulty:
        writer.writeByte(3);
        break;
      case CardSortType.memorized:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardSortTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardLayoutTypeAdapter extends TypeAdapter<CardLayoutType> {
  @override
  final int typeId = 6;

  @override
  CardLayoutType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardLayoutType.list;
      case 1:
        return CardLayoutType.slide;
      case 2:
        return CardLayoutType.grid;
      default:
        return CardLayoutType.list;
    }
  }

  @override
  void write(BinaryWriter writer, CardLayoutType obj) {
    switch (obj) {
      case CardLayoutType.list:
        writer.writeByte(0);
        break;
      case CardLayoutType.slide:
        writer.writeByte(1);
        break;
      case CardLayoutType.grid:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardLayoutTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardMaskingTypeAdapter extends TypeAdapter<CardMaskingType> {
  @override
  final int typeId = 7;

  @override
  CardMaskingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardMaskingType.word;
      case 1:
        return CardMaskingType.meaning;
      case 2:
        return CardMaskingType.none;
      default:
        return CardMaskingType.word;
    }
  }

  @override
  void write(BinaryWriter writer, CardMaskingType obj) {
    switch (obj) {
      case CardMaskingType.word:
        writer.writeByte(0);
        break;
      case CardMaskingType.meaning:
        writer.writeByte(1);
        break;
      case CardMaskingType.none:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardMaskingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordFilterModel _$WordFilterModelFromJson(Map<String, dynamic> json) =>
    WordFilterModel(
      maskingType: $enumDecode(_$CardMaskingTypeEnumMap, json['maskingType']),
      layoutType: $enumDecode(_$CardLayoutTypeEnumMap, json['layoutType']),
      sortType: $enumDecode(_$CardSortTypeEnumMap, json['sortType']),
    );

Map<String, dynamic> _$WordFilterModelToJson(WordFilterModel instance) =>
    <String, dynamic>{
      'maskingType': _$CardMaskingTypeEnumMap[instance.maskingType]!,
      'layoutType': _$CardLayoutTypeEnumMap[instance.layoutType]!,
      'sortType': _$CardSortTypeEnumMap[instance.sortType]!,
    };

const _$CardMaskingTypeEnumMap = {
  CardMaskingType.word: 'word',
  CardMaskingType.meaning: 'meaning',
  CardMaskingType.none: 'none',
};

const _$CardLayoutTypeEnumMap = {
  CardLayoutType.list: 'list',
  CardLayoutType.slide: 'slide',
  CardLayoutType.grid: 'grid',
};

const _$CardSortTypeEnumMap = {
  CardSortType.createdAt: 'createdAt',
  CardSortType.oldestFirst: 'oldestFirst',
  CardSortType.alphabetical: 'alphabetical',
  CardSortType.difficulty: 'difficulty',
  CardSortType.memorized: 'memorized',
};
