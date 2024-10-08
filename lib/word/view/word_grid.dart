import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/provider/target_word_book_provider.dart';
import 'package:perfect_wordbook/common/provider/word_card_list_provider.dart';
import 'package:perfect_wordbook/common/provider/word_filter_provider.dart';
import 'package:perfect_wordbook/common/utils/utils.dart';
import 'package:perfect_wordbook/common/constant/toast.dart';

class WordGrid extends ConsumerStatefulWidget {
  final List<WordCardModel> cards;
  final String wordBookKey;
  final bool isMaskingWord;

  const WordGrid({
    Key? key,
    required this.cards,
    required this.wordBookKey,
    required this.isMaskingWord,
  }) : super(key: key);

  @override
  _WordGridState createState() => _WordGridState();
}

class _WordGridState extends ConsumerState<WordGrid> {
  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isLongPressed = true;
        });
        showLongPressToast(context, widget.isMaskingWord);
      },
      onLongPressEnd: (_) {
        setState(() {
          isLongPressed = false;
        });
        removeLongPressToast();
      },
      child: ListView.builder(
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          final card = widget.cards[index];
          final fontSize = ref.watch(wordFilterProvider).fontSize;
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.isMaskingWord
                            ? (isLongPressed ? card.word : card.meaning)
                            : (isLongPressed ? card.meaning : card.word),
                        style: TextStyle(
                            fontSize: fontSize['word']!,
                            fontWeight: FontWeight.bold),
                      ),
                      if (((widget.isMaskingWord && isLongPressed) ||
                              (!widget.isMaskingWord && !isLongPressed)) &&
                          card.pronounce.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '[${card.pronounce}]',
                              style: TextStyle(
                                fontSize: fontSize['pronounce']! + 1,
                                fontWeight: FontWeight.w500,
                                color: BODY_TEXT_COLOR,
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  icon: getCardFormatIcon(format: card.format),
                  onPressed: () async {
                    final newFormat = getCardNextFormat(card.format);
                    await ref
                        .read(wordCardListProvider(widget.wordBookKey).notifier)
                        .updateCard(card.key, format: newFormat);
                    await ref
                        .read(targetWordBookProvider.notifier)
                        .updateCount();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
