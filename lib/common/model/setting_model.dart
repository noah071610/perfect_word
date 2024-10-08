import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 9)
class SettingModel {
  @JsonKey()
  @HiveField(0)
  final int themeNum;

  @JsonKey()
  @HiveField(1)
  final String language;

  @JsonKey()
  @HiveField(2)
  final String font;

  SettingModel({
    required this.themeNum,
    required this.language,
    required this.font,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingModelToJson(this);

  SettingModel copyWith({
    String? language,
    String? font,
    int? themeNum,
  }) {
    return SettingModel(
      language: language ?? this.language,
      themeNum: themeNum ?? this.themeNum,
      font: font ?? this.font,
    );
  }
}
