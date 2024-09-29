// import 'package:hive/hive.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:perfect_memo/common/utils/utils.dart';

// part 'memo_list_model.g.dart';

// @JsonSerializable()
// @HiveType(typeId: 0)
// class MemoModel {
//   @JsonKey()
//   @HiveField(0)
//   final String key;

//   @JsonKey()
//   @HiveField(1)
//   final MemoModel list;

//   @JsonKey()
//   @HiveField(2)
//   final String meaning;

//   MemoModel({
//     required this.word,
//     required this.meaning,
//     required this.key,
//   });

//   factory MemoModel.fromJson(Map<String, dynamic> json) =>
//       _$MemoModelFromJson(json);

//   Map<String, dynamic> toJson() => _$MemoModelToJson(this);

//   MemoModel copyWith({
//     String? word,
//     String? meaning,
//     String? key,
//   }) {
//     return MemoModel(
//       word: word ?? this.word,
//       meaning: meaning ?? this.meaning,
//       key: key ?? this.key,
//     );
//   }
// }
