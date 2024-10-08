import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/hive/word_card_list_hive.dart';
import 'package:perfect_wordbook/common/model/target_word_book_model.dart';
import 'package:perfect_wordbook/common/model/word_book_list_model.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/provider/word_book_list_provider.dart';
import 'package:perfect_wordbook/common/provider/word_card_list_provider.dart';

final targetWordBookProvider =
    StateNotifierProvider<TargetWordBookNotifier, TargetWordBookModel>((ref) {
  return TargetWordBookNotifier(ref);
});

class TargetWordBookNotifier extends StateNotifier<TargetWordBookModel> {
  final Ref _ref;

  TargetWordBookNotifier(this._ref)
      : super(TargetWordBookModel(
          wordBookKey: '',
          wordBookLanguage: '',
          wordBookListKey: '',
          wordBookTitle: '',
        ));

  Future<void> initializeTargetWordBook(
    String wordBookListKey,
    String wordBookKey,
  ) async {
    final wordBookList = _ref.read(wordBookListProvider);
    final targetWordBookList = wordBookList.firstWhere(
      (list) => list.key == wordBookListKey,
      orElse: () => throw Exception('WordBookList not found'),
    );

    final targetWordBook = targetWordBookList.wordBookList.firstWhere(
      (book) => book.key == wordBookKey,
      orElse: () => throw Exception('WordBook not found'),
    );

    state = TargetWordBookModel(
      wordBookKey: targetWordBook.key,
      wordBookLanguage: targetWordBook.language,
      wordBookListKey: wordBookListKey,
      wordBookTitle: targetWordBook.title,
    );
  }

  void updateWordBookTitle(String newTitle) {
    state = state.copyWith(wordBookTitle: newTitle);
    _ref.read(wordBookListProvider.notifier).changeWordBookTitle(
          state.wordBookListKey,
          state.wordBookKey,
          newTitle,
        );
  }

  Future<void> removeWordBook() async {
    final List<WordBookListModel> list = _ref.read(wordBookListProvider);

    final updatedList = list.map((wordBookList) {
      if (wordBookList.key == state.wordBookListKey) {
        final updatedWordBooks = wordBookList.wordBookList
            .where((wordBook) => wordBook.key != state.wordBookKey)
            .toList();
        return wordBookList.copyWith(wordBookList: updatedWordBooks);
      }
      return wordBookList;
    }).toList();

    await removeWordBookFromHive(_ref, state.wordBookKey);
    await _ref.read(wordBookListProvider.notifier).update(updatedList);
  }

  Future<void> updateCount() async {
    final List<WordBookListModel> list = _ref.read(wordBookListProvider);
    final List<WordCardModel> cards =
        _ref.read(wordCardListProvider(state.wordBookKey));

    final int memorizedCount =
        cards.where((card) => card.format == CardFormat.memorized).length;
    final int difficultyCount =
        cards.where((card) => card.format == CardFormat.difficulty).length;

    final updatedWordBookList = list
        .map((e) => e.key == state.wordBookListKey
            ? e.copyWith(
                wordBookList: e.wordBookList
                    .map((book) => book.key == state.wordBookKey
                        ? book.copyWith(
                            memorizedWordCount: memorizedCount,
                            difficultyWordCount: difficultyCount,
                            wordCount: cards.length)
                        : book)
                    .toList())
            : e)
        .toList();
    await _ref.read(wordBookListProvider.notifier).update(updatedWordBookList);
  }
}
