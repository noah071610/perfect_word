// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_book_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordBookListModelAdapter extends TypeAdapter<WordBookListModel> {
  @override
  final int typeId = 0;

  @override
  WordBookListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordBookListModel(
      key: fields[0] as String,
      title: fields[1] as String,
      bookList: (fields[2] as List).cast<WordBookModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, WordBookListModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.bookList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordBookListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordBookListModel _$WordBookListModelFromJson(Map<String, dynamic> json) =>
    WordBookListModel(
      key: json['key'] as String,
      title: json['title'] as String,
      bookList: (json['bookList'] as List<dynamic>)
          .map((e) => WordBookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WordBookListModelToJson(WordBookListModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'bookList': instance.bookList,
    };
