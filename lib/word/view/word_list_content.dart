import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:perfect_wordbook/common/constant/toast.dart';
import 'package:perfect_wordbook/common/model/word_book_model.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/provider/target_word_book_provider.dart';
import 'package:perfect_wordbook/common/provider/word_book_list_provider.dart';
import 'package:perfect_wordbook/common/provider/word_card_list_provider.dart';
import 'package:perfect_wordbook/common/provider/word_filter_provider.dart';

import 'package:perfect_wordbook/common/utils/utils.dart';
import 'package:perfect_wordbook/common/widgets/country_image.dart';

// COMP: 카드 컨텐츠
class CardMainContent extends ConsumerWidget {
  const CardMainContent({
    super.key,
    required this.card,
    required this.index,
    required this.hideWord,
    required this.hideMeaning,
    required this.onTap,
  });

  final WordCardModel card;
  final int index;
  final bool hideWord;
  final bool hideMeaning;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, ref) {
    final fontSize = ref.watch(wordFilterProvider).fontSize;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // TIP: 전체 클릭 가능
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              hideWord
                  ? HiddenTextWidget(
                      text: card.word,
                      fontSize: fontSize['word']!,
                      height: fontSize['word']! + 1 + fontSize['value']!,
                    )
                  : Text(
                      card.word,
                      style: TextStyle(
                        fontSize: fontSize['word']!,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
              if (card.pronounce.isNotEmpty)
                hideWord
                    ? HiddenTextWidget(
                        text: card.pronounce,
                        fontSize: fontSize['pronounce']!,
                        height: fontSize['pronounce']! + 1,
                      )
                    : Text(
                        '[${card.pronounce}]',
                        style: TextStyle(
                          fontSize: fontSize['pronounce']!,
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
              SizedBox(height: 12),
              hideMeaning
                  ? HiddenTextWidget(
                      text: card.meaning,
                      fontSize: fontSize['meaning']!,
                      height: fontSize['meaning']! + 2,
                    )
                  : Text(
                      card.meaning,
                      style: TextStyle(
                        fontSize: fontSize['meaning']!,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// COMP: MASKING
class HiddenTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final double height;

  const HiddenTextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: getTextSize(
            context,
            text,
            TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ).width,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}

// COMP: 카드 플로팅 메뉴
class CardIcons extends ConsumerWidget {
  const CardIcons({
    super.key,
    required this.targetIndex,
    required this.card,
  });

  final WordCardModel card;
  final int targetIndex;

  void _showMoveCardDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final wordBookListArr = ref.watch(wordBookListProvider);
        final targetBook = ref.watch(targetWordBookProvider);
        final List<WordBookModel> wordBookList = wordBookListArr
            .expand((wordBookList) => wordBookList.wordBookList)
            .where((e) => e.key != targetBook.wordBookKey)
            .toList();

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('move_to_word_book'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            wordBookList.length,
                            (index) {
                              final WordBookModel selectedBook =
                                  wordBookList[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          children: [
                                            CountryImage(
                                              language: selectedBook.language,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(selectedBook.title),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      final cards = ref.read(
                                          wordCardListProvider(
                                              targetBook.wordBookKey));
                                      final card = cards[targetIndex];
                                      await ref
                                          .read(wordCardListProvider(
                                                  selectedBook.key)
                                              .notifier)
                                          .addCard(card.word, card.meaning,
                                              card.pronounce,
                                              format: card.format);
                                      await ref
                                          .read(wordCardListProvider(
                                                  targetBook.wordBookKey)
                                              .notifier)
                                          .removeCard(card.key);

                                      await ref
                                          .read(targetWordBookProvider.notifier)
                                          .updateCount(
                                              forceKey: selectedBook.key,
                                              forceBookListKey:
                                                  selectedBook.key);
                                      await ref
                                          .read(targetWordBookProvider.notifier)
                                          .updateCount();
                                      // 여기에 선택된 단어장으로 카드를 이동하는 로직 추가
                                      showCustomToast(
                                        context: context,
                                        message:
                                            context.tr('move_to_word_complete'),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  if (index < wordBookList.length - 1)
                                    Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            context.tr('cancel'),
                            style: TextStyle(
                              color: Colors.red[600],
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: -16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogTheme.backgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, size: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordBook = ref.watch(targetWordBookProvider);
    final cardList =
        ref.read(wordCardListProvider(wordBook.wordBookKey).notifier);

    final fontSize = ref.read(wordFilterProvider).fontSize;

    return Positioned(
      top: 5 + fontSize['value']!,
      right: -10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: getCardFormatIcon(format: card.format),
            onPressed: () async {
              final newFormat = getCardNextFormat(card.format);
              await cardList.updateCard(card.key, format: newFormat);
              await ref.read(targetWordBookProvider.notifier).updateCount();
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: BODY_TEXT_COLOR),
            onSelected: (String result) {
              switch (result) {
                case 'edit':
                  context.go('/word_book/add', extra: {
                    'targetIndex': 2,
                    'wordKey': card.key,
                  });
                  break;
                case 'delete':
                  cardList.removeCard(card.key);
                  break;
                case 'move':
                  _showMoveCardDialog(context, ref);
                  break;
                default:
              }
              // 여기에 선택된 메뉴 항목에 대한 동작을 추가하세요
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: BODY_TEXT_COLOR,
                    ),
                    SizedBox(width: 8),
                    Text(context.tr('edit_word')),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'move',
                child: Row(
                  children: [
                    Icon(
                      Icons.move_to_inbox,
                      color: BODY_TEXT_COLOR,
                    ),
                    SizedBox(width: 8),
                    Text(context.tr('move_to_word_book')),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red[300]),
                    SizedBox(width: 8),
                    Text(context.tr('delete_word'),
                        style: TextStyle(color: Colors.red[300])),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
