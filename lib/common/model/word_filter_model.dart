import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_filter_model.g.dart';

@HiveType(typeId: 5)
enum CardSortType {
  @HiveField(0)
  createdAt,
  @HiveField(1)
  oldestFirst,
  @HiveField(2)
  alphabetical,
  @HiveField(3)
  difficulty,
  @HiveField(4)
  memorized,
}

@HiveType(typeId: 6)
enum CardLayoutType {
  @HiveField(0)
  list,
  @HiveField(1)
  slide,
  @HiveField(2)
  grid,
}

@HiveType(typeId: 7)
enum CardMaskingType {
  @HiveField(0)
  word,
  @HiveField(1)
  meaning,
  @HiveField(2)
  none,
}

@JsonSerializable()
@HiveType(typeId: 4)
class WordFilterModel {
  @JsonKey()
  @HiveField(0)
  final CardMaskingType maskingType;

  @JsonKey()
  @HiveField(1)
  final CardLayoutType layoutType;

  @JsonKey()
  @HiveField(2)
  final CardSortType sortType;

  WordFilterModel({
    required this.maskingType,
    required this.layoutType,
    required this.sortType,
  });

  factory WordFilterModel.fromJson(Map<String, dynamic> json) =>
      _$WordFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordFilterModelToJson(this);

  WordFilterModel copyWith({
    CardMaskingType? maskingType,
    CardLayoutType? layoutType,
    CardSortType? sortType,
  }) {
    return WordFilterModel(
      maskingType: maskingType ?? this.maskingType,
      layoutType: layoutType ?? this.layoutType,
      sortType: sortType ?? this.sortType,
    );
  }
}
