import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'target_word_book_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class TargetWordBookModel {
  @JsonKey()
  @HiveField(0)
  final String wordBookListKey;

  @JsonKey()
  @HiveField(1)
  final String wordBookKey;

  @JsonKey()
  @HiveField(2)
  final String wordBookTitle;

  @JsonKey()
  @HiveField(3)
  final String wordBookLanguage;

  TargetWordBookModel({
    required this.wordBookListKey,
    required this.wordBookKey,
    required this.wordBookTitle,
    required this.wordBookLanguage,
  });

  factory TargetWordBookModel.fromJson(Map<String, dynamic> json) =>
      _$TargetWordBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$TargetWordBookModelToJson(this);

  TargetWordBookModel copyWith({
    String? wordBookListKey,
    String? wordBookKey,
    String? wordBookTitle,
    String? wordBookLanguage,
  }) {
    return TargetWordBookModel(
      wordBookListKey: wordBookListKey ?? this.wordBookListKey,
      wordBookKey: wordBookKey ?? this.wordBookKey,
      wordBookTitle: wordBookTitle ?? this.wordBookTitle,
      wordBookLanguage: wordBookLanguage ?? this.wordBookLanguage,
    );
  }
}
