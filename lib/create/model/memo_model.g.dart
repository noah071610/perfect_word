// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoModel _$MemoModelFromJson(Map<String, dynamic> json) => MemoModel(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      key: json['key'] as String,
    );

Map<String, dynamic> _$MemoModelToJson(MemoModel instance) => <String, dynamic>{
      'key': instance.key,
      'word': instance.word,
      'meaning': instance.meaning,
    };
