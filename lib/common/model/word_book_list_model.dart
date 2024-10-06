import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:perfect_memo/common/model/word_book_model.dart';

part 'word_book_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class WordBookListModel {
  @JsonKey()
  @HiveField(0)
  final String key;

  @JsonKey()
  @HiveField(1)
  final String title;

  @JsonKey()
  @HiveField(2)
  final List<WordBookModel> wordBookList;

  WordBookListModel({
    required this.key,
    required this.title,
    required this.wordBookList,
  });

  factory WordBookListModel.fromJson(Map<String, dynamic> json) =>
      _$WordBookListModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordBookListModelToJson(this);

  WordBookListModel copyWith({
    String? key,
    String? title,
    List<WordBookModel>? wordBookList,
  }) {
    return WordBookListModel(
      key: key ?? this.key,
      title: title ?? this.title,
      wordBookList: wordBookList ?? this.wordBookList,
    );
  }
}
