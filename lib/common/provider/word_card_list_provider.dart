import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/hive/word_card_list_hive.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/model/word_filter_model.dart';
import 'package:perfect_wordbook/common/provider/word_filter_provider.dart';
import 'package:perfect_wordbook/common/utils/utils.dart';

// 필터링된 단어 카드 목록을 제공하는 프로바이더
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredWordCardListProvider =
    Provider.family<List<WordCardModel>, String>((ref, wordBookKey) {
  final cards = ref.watch(wordCardListProvider(wordBookKey));
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  if (searchQuery.isEmpty) {
    return cards;
  }

  return cards
      .where((card) =>
          card.word.toLowerCase().contains(searchQuery) ||
          card.meaning.toLowerCase().contains(searchQuery) ||
          card.pronounce.toLowerCase().contains(searchQuery))
      .toList();
});

// 필터링 및 정렬 로직
List<WordCardModel> _filterAndSortWordCards(
    List<WordCardModel> cards, WordFilterModel filter) {
  var filteredCards = cards;
  if (filteredCards.isEmpty) return [];

  // 정렬 로직
  switch (filter.sortType) {
    case CardSortType.createdAt:
      filteredCards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case CardSortType.oldestFirst:
      filteredCards.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case CardSortType.alphabetical:
      filteredCards
          .sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()));
      break;
    case CardSortType.difficulty:
      filteredCards.sort((a, b) {
        if (a.format == CardFormat.memorized) {
          return 1;
        } else if (b.format == CardFormat.memorized) {
          return -1;
        } else if (a.format == CardFormat.difficulty &&
            b.format != CardFormat.difficulty) {
          return -1;
        } else if (a.format != CardFormat.difficulty &&
            b.format == CardFormat.difficulty) {
          return 1;
        } else {
          return b.format.index.compareTo(a.format.index);
        }
      });
      break;
    case CardSortType.memorized:
      filteredCards.sort((a, b) {
        if (a.format == CardFormat.memorized &&
            b.format != CardFormat.memorized) {
          return -1;
        } else if (a.format != CardFormat.memorized &&
            b.format == CardFormat.memorized) {
          return 1;
        } else {
          return a.format.index.compareTo(b.format.index);
        }
      });
      break;
  }

  return filteredCards;
}

class wordCardListNotifier extends StateNotifier<List<WordCardModel>> {
  final Ref _ref;
  final String wordBookKey;

  wordCardListNotifier(this._ref, this.wordBookKey) : super([]) {
    _initializeWordCardList();
  }

  Future<void> _initializeWordCardList() async {
    final loadedList = await loadWordCardListFromHive(_ref, wordBookKey);
    state = loadedList;
  }

  addCard(String word, String meaning, String pronounce, String format) {
    state = [
      WordCardModel(
        key: generateRandomKey(),
        word: word,
        meaning: meaning,
        pronounce: pronounce,
        format: CardFormat.unchecked,
        createdAt: DateTime.now(),
      ),
      ...state,
    ];
    addWordCardListToHive(_ref, wordBookKey, state);
  }

  addGeneratedCards(List<WordCardModel> cards) {
    state = [
      ...cards,
      ...state,
    ];
    addWordCardListToHive(_ref, wordBookKey, state);
  }

  void shuffleCards() {
    final shuffledList = List<WordCardModel>.from(state)..shuffle();
    state = shuffledList;
    updateWordCardListInHive(_ref, wordBookKey, state);
  }

  removeCard(String key) {
    state = state.where((card) => card.key != key).toList();
    removeWordCardFromHive(_ref, wordBookKey, key);
  }

  updateCard(String key,
      {String? word,
      String? meaning,
      String? pronounce,
      CardFormat? format,
      int? level}) {
    state = state.map((card) {
      if (card.key == key) {
        return card.copyWith(
          word: word ?? card.word,
          meaning: meaning ?? card.meaning,
          pronounce: pronounce ?? card.pronounce,
          format: format ?? card.format,
        );
      }
      return card;
    }).toList();
    updateWordCardListInHive(_ref, wordBookKey, state);
  }

  // 필터 변경 시 호출되는 메서드 수정
  void applyFilter(WordFilterModel filter) {
    var sortedCards = _filterAndSortWordCards(state, filter);
    state = [...sortedCards];
  }
}

// 기존 wordCardListProvider 유지
final wordCardListProvider = StateNotifierProvider.family<wordCardListNotifier,
    List<WordCardModel>, String>((ref, wordBookKey) {
  final notifier = wordCardListNotifier(ref, wordBookKey);

  // 필터 변경 감지 및 적용
  ref.listen<WordFilterModel>(wordFilterProvider, (_, newFilter) {
    notifier.applyFilter(newFilter);
  });

  return notifier;
});
