import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:perfect_wordbook/common/constant/toast.dart';
import 'package:perfect_wordbook/common/provider/target_word_book_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:perfect_wordbook/common/provider/word_filter_provider.dart';
import 'package:perfect_wordbook/common/model/word_filter_model.dart';
import 'package:perfect_wordbook/common/widgets/confirm_dialog.dart';
import 'package:perfect_wordbook/common/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:perfect_wordbook/common/widgets/font_size_slider.dart';

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
                  title: context.tr('masking'),
                  icon: CupertinoIcons.eye_slash,
                  child: Column(
                    children: [
                      _buildRadioButton<CardMaskingType>(
                        context.tr('no_masking'),
                        wordFilter.maskingType,
                        CardMaskingType.none,
                        (value) => ref
                            .read(wordFilterProvider.notifier)
                            .updateMaskSetting(CardMaskingType.none),
                      ),
                      _buildRadioButton<CardMaskingType>(
                        context.tr('hide_word'),
                        wordFilter.maskingType,
                        CardMaskingType.word,
                        (value) => ref
                            .read(wordFilterProvider.notifier)
                            .updateMaskSetting(CardMaskingType.word),
                      ),
                      _buildRadioButton<CardMaskingType>(
                        context.tr('hide_meaning'),
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
                  title: context.tr('layout_type'),
                  icon: CupertinoIcons.square_grid_2x2,
                  child: Column(
                    children: [
                      _buildRadioButton<CardLayoutType>(
                          context.tr('list_card'),
                          wordFilter.layoutType,
                          CardLayoutType.list,
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateLayoutTypeSetting(CardLayoutType.list)),
                      _buildRadioButton<CardLayoutType>(
                          context.tr('slide'),
                          wordFilter.layoutType,
                          CardLayoutType.slide,
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateLayoutTypeSetting(CardLayoutType.slide)),
                      _buildRadioButton<CardLayoutType>(
                          context.tr('word_book'),
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
                  title: context.tr('sort'),
                  icon: CupertinoIcons.sort_down,
                  child: Column(
                    children: [
                      _buildRadioButton(
                          context.tr('input_order'),
                          wordFilter.sortType.toString(),
                          CardSortType.createdAt.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.createdAt)),
                      _buildRadioButton(
                          context.tr('oldest_first'),
                          wordFilter.sortType.toString(),
                          CardSortType.oldestFirst.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.oldestFirst)),
                      _buildRadioButton(
                          context.tr('alphabetical_order'),
                          wordFilter.sortType.toString(),
                          CardSortType.alphabetical.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(
                                  CardSortType.alphabetical)),
                      _buildRadioButton(
                          context.tr('difficulty_order'),
                          wordFilter.sortType.toString(),
                          CardSortType.difficulty.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.difficulty)),
                      _buildRadioButton(
                          context.tr('memorized_order'),
                          wordFilter.sortType.toString(),
                          CardSortType.memorized.toString(),
                          (value) => ref
                              .read(wordFilterProvider.notifier)
                              .updateSortTypeSetting(CardSortType.memorized)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                _buildFilterSection(
                  title: context.tr('font_size'),
                  icon: CupertinoIcons.textformat_size,
                  child: FontSizeSlider(),
                ),
                CustomButton(
                  onSubmit: () {
                    confirmDialog(
                      context: context,
                      onPressed: () async {
                        await ref
                            .read(targetWordBookProvider.notifier)
                            .removeWordBook();
                        showCustomToast(
                            context: context,
                            message: context.tr('delete_completed'));
                        Navigator.of(context).pop();
                        context.go('/');
                      },
                      title: context.tr('delete_word_book'),
                      content: context.tr('confirm_delete_word_book'),
                    );
                  },
                  text: context.tr('delete_word_book'),
                  isWarning: true,
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
