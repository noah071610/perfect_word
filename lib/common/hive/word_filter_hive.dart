import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/hive/hive.dart';
import 'package:perfect_memo/common/model/word_filter_model.dart';

Future<WordFilterModel> loadSettingFromHive(Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel settingData = box.get('setting',
      defaultValue: WordFilterModel(
        maskingType: CardMaskingType.none,
        layoutType: CardLayoutType.list,
        sortType: CardSortType.createdAt,
      ));

  return settingData;
}

Future<WordFilterModel> updateMaskSettingInHive(
    Ref<Object?> ref, CardMaskingType value) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel currentSetting = box.get('setting',
      defaultValue: WordFilterModel(
        maskingType: CardMaskingType.none,
        layoutType: CardLayoutType.list,
        sortType: CardSortType.createdAt,
      ));

  final updatedSetting = currentSetting.copyWith(maskingType: value);
  await box.put('setting', updatedSetting);
  return updatedSetting;
}

Future<WordFilterModel> updateLayoutTypeSettingInHive(
    Ref<Object?> ref, CardLayoutType value) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel currentSetting = box.get('setting',
      defaultValue: WordFilterModel(
        maskingType: CardMaskingType.none,
        layoutType: CardLayoutType.list,
        sortType: CardSortType.createdAt,
      ));

  final updatedSetting = currentSetting.copyWith(layoutType: value);
  await box.put('setting', updatedSetting);
  return updatedSetting;
}

Future<WordFilterModel> updateSortTypeSettingInHive(
    Ref<Object?> ref, CardSortType value) async {
  final box = await ref.read(boxProvider('setting').future);
  final WordFilterModel currentSetting = box.get('setting',
      defaultValue: WordFilterModel(
        maskingType: CardMaskingType.none,
        layoutType: CardLayoutType.list,
        sortType: CardSortType.createdAt,
      ));

  final updatedSetting = currentSetting.copyWith(sortType: value);
  await box.put('setting', updatedSetting);
  return updatedSetting;
}
