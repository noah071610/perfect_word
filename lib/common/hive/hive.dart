import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

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
