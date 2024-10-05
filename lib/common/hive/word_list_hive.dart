import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/hive/hive.dart';
import 'package:perfect_memo/common/model/word_book_list_model.dart';
import 'package:perfect_memo/common/model/word_book_model.dart';
import 'package:perfect_memo/common/utils/utils.dart';

Future<List<WordBookListModel>> loadWordBookListFromHive(
    Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('word_book_list').future);
  final List<dynamic> rawList = box.get('word_book_list', defaultValue: [
    WordBookListModel(
      key: generateRandomKey(),
      title: '내 단어장',
      bookList: [],
    ),
    WordBookListModel(
      key: 'supplement',
      title: '부록',
      bookList: [
        WordBookModel(
          key: 'difficulty',
          title: '어려운 단어 표시',
          createdAt: DateTime.now(),
          wordCount: 0,
          checkedWordCount: 0,
          difficultyWordCount: 0,
          language: 'global',
        ),
        WordBookModel(
          key: 'checked',
          title: '삭제 단어',
          createdAt: DateTime.now(),
          wordCount: 0,
          checkedWordCount: 0,
          difficultyWordCount: 0,
          language: 'global',
        )
      ],
    )
  ]);

  List<WordBookListModel> result = [];
  for (var item in rawList) {
    if (item is WordBookListModel) {
      result.add(item);
    } else if (item is Map<String, dynamic>) {
      try {
        result.add(WordBookListModel.fromJson(item));
      } catch (e) {}
    } else {}
  }

  return result;
}
