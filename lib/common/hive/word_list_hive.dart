import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/hive/hive.dart';
import 'package:perfect_wordbook/common/model/word_book_list_model.dart';
import 'package:perfect_wordbook/common/utils/utils.dart';

Future<List<WordBookListModel>> loadWordBookListFromHive(
    Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('word_book_list').future);
  final List<dynamic> rawList = box.get('word_book_list', defaultValue: [
    WordBookListModel(
      key: generateRandomKey(),
      title: 'My Words',
      wordBookList: [],
    ),
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

Future<void> updateWordBookListInHive(
    Ref<Object?> ref, List<WordBookListModel> updatedWordList) async {
  final box = await ref.read(boxProvider('word_book_list').future);
  await box.put('word_book_list', updatedWordList);
}
