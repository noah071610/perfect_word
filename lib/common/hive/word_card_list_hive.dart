import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/hive/hive.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';

Future<List<WordCardModel>> loadWordCardListFromHive(
    Ref ref, String wordBookKey) async {
  final key = 'word_card_list_$wordBookKey';
  final box = await ref.read(boxProvider(key).future);
  final List<dynamic> _wordCardList = box.get(key, defaultValue: []);

  final List<WordCardModel> wordCardList = _wordCardList.length > 0
      ? _wordCardList
          .map((entry) =>
              WordCardModel.fromJson(Map<String, dynamic>.from(entry)))
          .toList()
      : [];

  return wordCardList;
}

Future<void> addWordCardListToHive(Ref<Object?> ref, String wordBookKey,
    List<WordCardModel> wordCardList) async {
  final key = 'word_card_list_$wordBookKey';
  final box = await ref.read(boxProvider(key).future);
  await box.put(key, wordCardList.map((card) => card.toJson()).toList());
}

Future<void> updateWordCardListInHive(Ref<Object?> ref, String wordBookKey,
    List<WordCardModel> updatedWordCardList) async {
  await addWordCardListToHive(ref, wordBookKey, updatedWordCardList);
}

Future<void> removeWordCardFromHive(
    Ref<Object?> ref, String wordBookKey, String cardKey) async {
  final key = 'word_card_list_$wordBookKey';
  final box = await ref.read(boxProvider(key).future);

  List<dynamic> wordCardList = box.get(key, defaultValue: []);
  wordCardList.removeWhere((card) => card['key'] == cardKey);

  await box.put(key, wordCardList);
}
