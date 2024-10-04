import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:perfect_memo/common/model/word_book_list_model.dart';

final hiveProvider = Provider<HiveInterface>((ref) {
  return Hive;
});

final boxProvider = FutureProvider.family<Box, String>((ref, boxName) async {
  final hive = ref.watch(hiveProvider);
  if (!hive.isBoxOpen(boxName)) {
    return await hive.openBox(boxName);
  }
  return hive.box(boxName);
});

Future<void> updateWordBookListInHive(
    Ref<Object?> ref, List<WordBookListModel> updatedWordList) async {
  final box = await ref.read(boxProvider('word_book_list').future);
  await box.put('word_book_list', updatedWordList);
}
