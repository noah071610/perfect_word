import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_wordbook/common/constant/toast.dart';
import 'package:perfect_wordbook/common/model/target_word_book_model.dart';
import 'package:perfect_wordbook/common/provider/target_word_book_provider.dart';
import 'package:perfect_wordbook/common/provider/word_card_list_provider.dart';
import 'package:perfect_wordbook/common/widgets/custom_button.dart';
import 'package:perfect_wordbook/common/widgets/floating_label_text_field.dart';

class ManualInputForm extends ConsumerWidget {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();
  final TextEditingController pronounceController = TextEditingController();
  final FocusNode wordFocus = FocusNode();
  final FocusNode meaningFocus = FocusNode();
  final FocusNode pronounceFocus = FocusNode();
  final BuildContext context;
  final String? wordKey;

  ManualInputForm({
    Key? key,
    required this.context,
    this.wordKey,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onSubmit(WidgetRef ref, TargetWordBookModel book) async {
    if (_formKey.currentState!.validate()) {
      if (wordKey != null) {
        // 기존 단어 카드 업데이트
        ref.read(wordCardListProvider(book.wordBookKey).notifier).updateCard(
              wordKey!,
              word: wordController.text,
              meaning: meaningController.text,
              pronounce: pronounceController.text,
            );

        showCustomToast(
            context: context, message: context.tr('change_completed'));
        context.go('/word_book');
      } else {
        // 새 단어 카드 추가
        await ref.read(wordCardListProvider(book.wordBookKey).notifier).addCard(
              wordController.text,
              meaningController.text,
              pronounceController.text,
              'default',
            );
        await ref.read(targetWordBookProvider.notifier).updateCount();

        wordController.text = '';
        meaningController.text = '';
        pronounceController.text = '';
        wordFocus.requestFocus();
        showCustomToast(context: context, message: context.tr('word_added'));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // wordKey가 있을 경우 해당 단어 카드 정보를 가져옵니다.
    final book = ref.read(targetWordBookProvider);

    if (wordKey != null) {
      final wordCards = ref.read(wordCardListProvider(book.wordBookKey));
      final wordCard = wordCards.firstWhere((card) => card.key == wordKey);

      // 텍스트 필드에 기존 값을 설정합니다.
      wordController.text = wordCard.word;
      meaningController.text = wordCard.meaning;
      pronounceController.text = wordCard.pronounce;
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          children: [
            FloatingLabelTextField(
              label: context.tr('enter_word'),
              autofocus: true,
              controller: wordController,
              focusNode: wordFocus,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(meaningFocus);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr('please_enter_word');
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            FloatingLabelTextField(
              label: context.tr('enter_meaning'),
              controller: meaningController,
              focusNode: meaningFocus,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(pronounceFocus);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr('please_enter_meaning');
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            FloatingLabelTextField(
              label: context.tr('enter_pronunciation'),
              controller: pronounceController,
              focusNode: pronounceFocus,
              onFieldSubmitted: (_) => {
                if (wordController.text.isNotEmpty &&
                    meaningController.text.isNotEmpty)
                  onSubmit(ref, book)
              },
            ),
            SizedBox(height: 30),
            CustomButton(
                onSubmit: () => {onSubmit(ref, book)},
                text: context.tr('enter_word')),
          ],
        ),
      ),
    );
  }
}
