// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordBookModelAdapter extends TypeAdapter<WordBookModel> {
  @override
  final int typeId = 1;

  @override
  WordBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordBookModel(
      key: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[2] as DateTime,
      wordCount: fields[3] as int,
      checkedWordCount: fields[4] as int,
      difficultyWordCount: fields[5] as int,
      language: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordBookModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.wordCount)
      ..writeByte(4)
      ..write(obj.checkedWordCount)
      ..writeByte(5)
      ..write(obj.difficultyWordCount)
      ..writeByte(6)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBookModel _$WordBookModelFromJson(Map<String, dynamic> json) =>
    WordBookModel(
      key: json['key'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      wordCount: (json['wordCount'] as num).toInt(),
      checkedWordCount: (json['checkedWordCount'] as num).toInt(),
      difficultyWordCount: (json['difficultyWordCount'] as num).toInt(),
      language: json['language'] as String,
    );

Map<String, dynamic> _$WordBookModelToJson(WordBookModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'wordCount': instance.wordCount,
      'checkedWordCount': instance.checkedWordCount,
      'difficultyWordCount': instance.difficultyWordCount,
      'language': instance.language,
    };
