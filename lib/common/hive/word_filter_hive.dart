import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/hive/hive.dart';
import 'package:perfect_memo/common/model/word_filter_model.dart';

final WordFilterModel defaultModel = WordFilterModel(
  maskingType: CardMaskingType.none,
  layoutType: CardLayoutType.list,
  sortType: CardSortType.createdAt,
  fontSize: {
    'word': 22,
    'pronounce': 14,
    'meaning': 16,
    'value': 3,
  },
);

Future<WordFilterModel> loadSettingFromHive(Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel settingData =
      box.get('setting', defaultValue: defaultModel);

  return settingData;
}

Future<WordFilterModel> updateMaskSettingInHive(
    Ref<Object?> ref, CardMaskingType value) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel currentSetting =
      box.get('setting', defaultValue: defaultModel);

  final updatedSetting = currentSetting.copyWith(maskingType: value);
  await box.put('setting', updatedSetting);
  return updatedSetting;
}

Future<WordFilterModel> updateLayoutTypeSettingInHive(
    Ref<Object?> ref, CardLayoutType value) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel currentSetting =
      box.get('setting', defaultValue: defaultModel);

  final updatedSetting = currentSetting.copyWith(layoutType: value);
  await box.put('setting', updatedSetting);
  return updatedSetting;
}

Future<WordFilterModel> updateSortTypeSettingInHive(
    Ref<Object?> ref, CardSortType value) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel currentSetting =
      box.get('setting', defaultValue: defaultModel);

  final updatedSetting = currentSetting.copyWith(sortType: value);
  await box.put('setting', updatedSetting);
  return updatedSetting;
}

Future<WordFilterModel> updateFontSizeSettingInHive(
    Ref<Object?> ref, double value) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel currentSetting =
      box.get('setting', defaultValue: defaultModel);

  final updatedSetting = currentSetting.copyWith(fontSize: getFontSize(value));
  await box.put('setting', updatedSetting);
  return updatedSetting;
}

Map<String, double> getFontSize(double value) {
  // 기본 폰트 크기 (value가 3일 때)
  final baseWord = 22.0;
  final basePronounce = 14.0;
  final baseMeaning = 16.0;

  // 크기 조정 계수 계산 (0.8에서 1.2 사이)
  final scaleFactor = 0.8 + (value - 1) * 0.1;

  return {
    'word': (baseWord * scaleFactor).roundToDouble(),
    'pronounce': (basePronounce * scaleFactor).roundToDouble(),
    'meaning': (baseMeaning * scaleFactor).roundToDouble(),
    'value': value,
  };
}
