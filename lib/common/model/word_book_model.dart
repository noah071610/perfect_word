import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_book_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class WordBookModel {
  @JsonKey()
  @HiveField(0)
  final String key;

  @JsonKey()
  @HiveField(1)
  final String title;

  @JsonKey()
  @HiveField(2)
  final DateTime createdAt;

  @JsonKey()
  @HiveField(3)
  final int wordCount;

  @JsonKey()
  @HiveField(4)
  final int memorizedWordCount;

  @JsonKey()
  @HiveField(5)
  final int difficultyWordCount;

  @JsonKey()
  @HiveField(6)
  final String language;

  WordBookModel({
    required this.key,
    required this.title,
    required this.createdAt,
    required this.wordCount,
    required this.memorizedWordCount,
    required this.difficultyWordCount,
    required this.language,
  });

  factory WordBookModel.fromJson(Map<String, dynamic> json) =>
      _$WordBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordBookModelToJson(this);

  WordBookModel copyWith({
    String? key,
    String? title,
    DateTime? createdAt,
    String? category,
    int? wordCount,
    int? memorizedWordCount,
    int? difficultyWordCount,
    String? language,
  }) {
    return WordBookModel(
      key: key ?? this.key,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      wordCount: wordCount ?? this.wordCount,
      memorizedWordCount: memorizedWordCount ?? this.memorizedWordCount,
      difficultyWordCount: difficultyWordCount ?? this.difficultyWordCount,
      language: language ?? this.language,
    );
  }
}
