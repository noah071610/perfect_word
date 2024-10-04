import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_card_model.g.dart';

@HiveType(typeId: 3)
enum CardFormat {
  @HiveField(0)
  unchecked,
  @HiveField(1)
  memorized,
  @HiveField(2)
  difficulty,
}

@JsonSerializable()
@HiveType(typeId: 2)
class WordCardModel {
  @JsonKey()
  @HiveField(0)
  final String key;

  @JsonKey()
  @HiveField(1)
  final String word;

  @JsonKey()
  @HiveField(2)
  final String meaning;

  @JsonKey()
  @HiveField(3)
  final String pronounce;

  @JsonKey()
  @HiveField(4)
  final CardFormat format;

  @JsonKey()
  @HiveField(5)
  final DateTime createdAt;

  WordCardModel({
    required this.key,
    required this.word,
    required this.meaning,
    required this.pronounce,
    required this.format,
    required this.createdAt,
  });

  factory WordCardModel.fromJson(Map<String, dynamic> json) =>
      _$WordCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordCardModelToJson(this);

  WordCardModel copyWith({
    String? key,
    String? word,
    String? meaning,
    String? pronounce,
    CardFormat? format,
    DateTime? createdAt,
  }) {
    return WordCardModel(
      key: key ?? this.key,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      pronounce: pronounce ?? this.pronounce,
      format: format ?? this.format,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
