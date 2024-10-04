import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/provider/word_filter_provider.dart';
import 'package:perfect_memo/common/model/word_filter_model.dart';

// COMP: filter sheet
class FilterSheet extends ConsumerWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final wordFilter = ref.watch(wordFilterProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                _buildFilterSection(
                  title: '마스킹',
                  icon: CupertinoIcons.eye_slash,
                  child: Column(
                    children: [
                      _buildRadioButton<CardMaskingType>(
                        '마스킹 없음',
                        wordFilter.maskingType,
                        CardMaskingType.none,
                        (value) => ref
                            .read(wordFilterProvider.notifier)
                            .updateMaskSetting(CardMaskingType.none),
                      ),
                      _buildRadioButton<CardMaskingType>(
                        '단어 가리기',
                        wordFilter.maskingType,
                        CardMaskingType.word,
                        (value) => ref
                            .read(wordFilterProvider.notifier)
                            .updateMaskSetting(CardMaskingType.word),
                      ),
                      _buildRadioButton<CardMaskingType>(
                        '뜻 가리기',
                        wordFilter.maskingType,
                        CardMaskingType.meaning,
                        (value) => ref
                            .read(wordFilterProvider.notifier)
                            .updateMaskSetting(CardMaskingType.meaning),
                      ),
                    ],
                  ),
                ),
                _buildFilterSection(
                  title: '배치 타입',
                  icon: CupertinoIcons.square_grid_2x2,
                  child: Column(
                    children: [
                      _buildRadioButton<CardLayoutType>(
                          '리스트 카드',
                          wordFilter.layoutType,
                          CardLayoutType.list,
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateLayoutTypeSetting(CardLayoutType.list)),
                      _buildRadioButton<CardLayoutType>(
                          '슬라이드',
                          wordFilter.layoutType,
                          CardLayoutType.slide,
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateLayoutTypeSetting(CardLayoutType.slide)),
                      _buildRadioButton<CardLayoutType>(
                          '단어장',
                          wordFilter.layoutType,
                          CardLayoutType.grid,
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateLayoutTypeSetting(CardLayoutType.grid)),
                    ],
                  ),
                ),
                _buildFilterSection(
                  isLast: true,
                  title: '정렬',
                  icon: CupertinoIcons.sort_down,
                  child: Column(
                    children: [
                      _buildRadioButton(
                          '입력 순',
                          wordFilter.sortType.toString(),
                          CardSortType.createdAt.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.createdAt)),
                      _buildRadioButton(
                          '오래된 순',
                          wordFilter.sortType.toString(),
                          CardSortType.oldestFirst.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.oldestFirst)),
                      _buildRadioButton(
                          '사전순',
                          wordFilter.sortType.toString(),
                          CardSortType.alphabetical.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(
                                  CardSortType.alphabetical)),
                      _buildRadioButton(
                          '어려운 순',
                          wordFilter.sortType.toString(),
                          CardSortType.difficulty.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.difficulty)),
                      _buildRadioButton(
                          '외운 순',
                          wordFilter.sortType.toString(),
                          CardSortType.memorized.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.memorized)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildFilterSection(
    {required String title,
    required IconData icon,
    required Widget child,
    bool? isLast}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      child,
      if (isLast != true) Divider(),
      SizedBox(height: 12),
    ],
  );
}

Widget _buildRadioButton<T>(
    String label, T groupValue, T value, Function(T?) onChanged) {
  return GestureDetector(
    onTap: () => onChanged(value),
    child: Row(
      children: [
        Expanded(
          child: Text(label),
        ),
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: BORDER_DEEP_COLOR,
          fillColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return BORDER_DEEP_COLOR;
            }
            return Colors.grey[400]!;
          }),
        )
      ],
    ),
  );
}

Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
  return GestureDetector(
    onTap: () => onChanged(value),
    child: Row(
      children: [
        Text(label),
        Checkbox(
          value: value,
          onChanged: onChanged,
          fillColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return BORDER_DEEP_COLOR; // 선택된 상태에서 배경색을 투명하게 설정
            }
            return Colors.transparent; // 선택되지 않은 상태에서도 배경색을 투명하게 설정
          }),
          checkColor: PRIMARY_COLOR, // 체크 아이콘 색상을 BORDER_COLOR로 설정
          side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return BorderSide(color: Colors.transparent); // 선택된 상태에서 테두리 색상
            }
            return BorderSide(color: Colors.grey[400]!); // 선택되지 않은 상태에서 테두리 색상
          }),
        ),
      ],
    ),
  );
}
