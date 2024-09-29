import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/create/model/memo_model.dart';

final memoProvider =
    StateNotifierProvider<MemoNotifier, Map<String, MemoModel>>((ref) {
  return MemoNotifier();
});

class MemoNotifier extends StateNotifier<Map<String, MemoModel>> {
  MemoNotifier() : super({});

  void loadMemos(Map<String, MemoModel> memos) {
    state = memos;
  }
}
