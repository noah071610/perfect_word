// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_word_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TargetWordBookModelAdapter extends TypeAdapter<TargetWordBookModel> {
  @override
  final int typeId = 8;

  @override
  TargetWordBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TargetWordBookModel(
      wordBookListKey: fields[0] as String,
      wordBookKey: fields[1] as String,
      wordBookTitle: fields[2] as String,
      wordBookLanguage: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TargetWordBookModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.wordBookListKey)
      ..writeByte(1)
      ..write(obj.wordBookKey)
      ..writeByte(2)
      ..write(obj.wordBookTitle)
      ..writeByte(3)
      ..write(obj.wordBookLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetWordBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetWordBookModel _$TargetWordBookModelFromJson(Map<String, dynamic> json) =>
    TargetWordBookModel(
      wordBookListKey: json['wordBookListKey'] as String,
      wordBookKey: json['wordBookKey'] as String,
      wordBookTitle: json['wordBookTitle'] as String,
      wordBookLanguage: json['wordBookLanguage'] as String,
    );

Map<String, dynamic> _$TargetWordBookModelToJson(
        TargetWordBookModel instance) =>
    <String, dynamic>{
      'wordBookListKey': instance.wordBookListKey,
      'wordBookKey': instance.wordBookKey,
      'wordBookTitle': instance.wordBookTitle,
      'wordBookLanguage': instance.wordBookLanguage,
    };
