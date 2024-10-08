import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/hive/word_filter_hive.dart';
import 'package:perfect_wordbook/common/model/word_filter_model.dart';

final wordFilterProvider =
    StateNotifierProvider<wordFilterNotifier, WordFilterModel>((ref) {
  return wordFilterNotifier(ref);
});

class wordFilterNotifier extends StateNotifier<WordFilterModel> {
  final Ref _ref;

  wordFilterNotifier(this._ref)
      : super(WordFilterModel(
          maskingType: CardMaskingType.none,
          layoutType: CardLayoutType.list,
          sortType: CardSortType.createdAt,
        )) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loadedList = await loadSettingFromHive(_ref);
    state = loadedList;
  }

  Future<void> updateMaskSetting(CardMaskingType value) async {
    final loadedList = await updateMaskSettingInHive(_ref, value);
    state = loadedList;
  }

  Future<void> updateLayoutTypeSetting(CardLayoutType value) async {
    final loadedList = await updateLayoutTypeSettingInHive(_ref, value);

    state = loadedList;
  }

  Future<void> updateSortTypeSetting(CardSortType value) async {
    final loadedList = await updateSortTypeSettingInHive(_ref, value);
    state = loadedList;
  }

  Future<void> updateFontSizeSetting(double value) async {
    final loadedList = await updateFontSizeSettingInHive(_ref, value);
    state = loadedList;
  }
}
