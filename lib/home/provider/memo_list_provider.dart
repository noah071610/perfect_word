import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/utils/utils.dart';
import 'package:perfect_memo/create/model/memo_model.dart';
import 'package:perfect_memo/common/hive/hive.dart';

final memoListProvider =
    StateNotifierProvider<MemoListNotifier, List<MemoModel>>((ref) {
  return MemoListNotifier(ref);
});

final selectedMemoProvider =
    StateProvider.family<MemoModel, String>((ref, memoKey) {
  final memoList = ref.watch(memoListProvider);
  final temp = memoList.firstWhere((memo) => memo.key == memoKey);
  return temp;
});

class MemoListNotifier extends StateNotifier<List<MemoModel>> {
  final Ref _ref;

  MemoListNotifier(
    this._ref,
  ) : super([]) {
    loadMemoListFromHive(_ref, state);
  }

  // 새로운 함수 추가
  Future<void> updateSelectedMemo(String memoKey, MemoModel updatedMemo) async {
    // state에서 해당 메모 찾아 업데이트
    state =
        state.map((memo) => memo.key == memoKey ? updatedMemo : memo).toList();
  }

  MemoModel addNewMemo(String memoKey) {
    final newMemo = MemoModel(word: '', meaning: '', key: memoKey);
    state = [...state, newMemo];
    return newMemo;
  }
}
