import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:perfect_memo/create/model/memo_model.dart';

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

Future<void> loadMemoListFromHive(
    Ref<Object?> ref, List<MemoModel> state) async {
  final box = await ref.read(boxProvider('memos').future);
  final memosMap = box.get('memos', defaultValue: <String, dynamic>{})
      as Map<String, dynamic>;
  final memoList =
      memosMap.entries.map((entry) => MemoModel.fromJson(entry.value)).toList();
  state = memoList;
}
