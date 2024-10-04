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
  final int checkedWordCount;

  WordBookModel({
    required this.key,
    required this.title,
    required this.createdAt,
    required this.wordCount,
    required this.checkedWordCount,
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
    int? checkedWordCount,
  }) {
    return WordBookModel(
      key: key ?? this.key,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      wordCount: wordCount ?? this.wordCount,
      checkedWordCount: checkedWordCount ?? this.checkedWordCount,
    );
  }
}
