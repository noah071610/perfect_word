import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/hive/hive.dart';
import 'package:perfect_wordbook/common/model/setting_model.dart';

Future<SettingModel> loadSettingFromHive(Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('setting').future);
  final SettingModel settings = box.get('setting',
      defaultValue: SettingModel(
        themeNum: 0,
        language: 'ko',
        font: 'Noto Sans',
      ));

  return settings;
}

Future<void> updateSettingInHive(Ref<Object?> ref, SettingModel state) async {
  final box = await ref.read(boxProvider('setting').future);
  await box.put('setting', state);
}
