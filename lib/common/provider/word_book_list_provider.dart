import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/hive/hive.dart';
import 'package:perfect_memo/common/hive/word_list_hive.dart';
import 'package:perfect_memo/common/model/word_book_list_model.dart';
import 'package:perfect_memo/common/model/word_book_model.dart';

final wordBookListProvider =
    StateNotifierProvider<wordBookListNotifier, List<WordBookListModel>>((ref) {
  return wordBookListNotifier(ref);
});

class wordBookListNotifier extends StateNotifier<List<WordBookListModel>> {
  final Ref _ref;

  wordBookListNotifier(this._ref) : super([]) {
    _initializeWordBookList();
  }

  Future<void> _initializeWordBookList() async {
    final loadedList = await loadWordBookListFromHive(_ref);
    state = loadedList;
  }

  Future<void> addWordBook(String listKey, String bookKey, String title) async {
    final newWordBookList = state
        .map((e) => e.key == listKey
            ? e.copyWith(bookList: [
                ...e.bookList,
                WordBookModel(
                  key: bookKey,
                  title: title,
                  createdAt: DateTime.now(),
                  checkedWordCount: 0,
                  wordCount: 0,
                )
              ])
            : e)
        .toList();
    state = newWordBookList;
    await updateWordBookListInHive(_ref, state);
  }

  Future<void> addWordBookList(String listKey, String title) async {
    final newWordBookList = WordBookListModel(
      key: listKey,
      title: title,
      bookList: [],
    );
    state = [...state, newWordBookList];
    await updateWordBookListInHive(_ref, state);
  }

  WordBookListModel findOne(String key) {
    return state.firstWhere((e) => e.key == key);
  }

  Future<void> removeWordBookList(String wordBookListKey) async {
    state = state.where((word) => !wordBookListKey.contains(word.key)).toList();
    await updateWordBookListInHive(_ref, state);
  }

  Future<void> changeWordBookTitle(
      String wordBookListKey, String wordBookKey, String newTitle) async {
    state = state.map((wordBookList) {
      if (wordBookList.key == wordBookListKey) {
        return wordBookList.copyWith(
          bookList: wordBookList.bookList.map((wordBook) {
            if (wordBook.key == wordBookKey) {
              return wordBook.copyWith(title: newTitle);
            }
            return wordBook;
          }).toList(),
        );
      }
      return wordBookList;
    }).toList();
    await updateWordBookListInHive(_ref, state);
  }

  Future<void> changeWordBooListTitle(
      String wordBookListKey, String newTitle) async {
    state = state
        .map((book) =>
            book.key == wordBookListKey ? book.copyWith(title: newTitle) : book)
        .toList();
    await updateWordBookListInHive(_ref, state);
  }

  Future<void> addWordBookWordCount(String key) async {
    state = state.map((wordBookList) {
      return wordBookList.copyWith(
        bookList: wordBookList.bookList.map((wordBook) {
          if (wordBook.key == key) {
            return wordBook.copyWith(
              wordCount: wordBook.wordCount + 1,
            );
          }
          return wordBook;
        }).toList(),
      );
    }).toList();
    await updateWordBookListInHive(_ref, state);
  }
}
