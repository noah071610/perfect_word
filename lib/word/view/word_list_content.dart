import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';
import 'package:perfect_memo/common/provider/word_card_list_provider.dart';

import 'package:perfect_memo/common/utils/utils.dart';

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
                      fontSize: 21,
                      height: 25,
                    )
                  : Text(
                      card.word,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              if (card.pronounce.isNotEmpty)
                hideWord
                    ? HiddenTextWidget(
                        text: card.pronounce,
                        fontSize: 14,
                        height: 15,
                      )
                    : Text(
                        '[${card.pronounce}]',
                        style: TextStyle(
                          fontSize: 14,
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
              SizedBox(height: 12),
              hideMeaning
                  ? HiddenTextWidget(
                      text: card.meaning,
                      fontSize: 16,
                      height: 18,
                    )
                  : Text(
                      card.meaning,
                      style: TextStyle(
                        fontSize: 16,
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
    required this.card,
    required this.wordBookKey,
    required this.wordBookListKey,
    required this.wordBookTitle,
  });

  final WordCardModel card;
  final String wordBookKey;
  final String wordBookListKey;
  final String wordBookTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 8,
      right: -10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: getCardFormatIcon(card.format),
            onPressed: () {
              final newFormat = getCardNextFormat(card.format);
              ref
                  .read(wordCardListProvider(wordBookKey).notifier)
                  .updateCard(card.key, format: newFormat);
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: BODY_TEXT_COLOR),
            onSelected: (String result) {
              switch (result) {
                case 'edit':
                  context.go('/word/add', extra: {
                    'title': '단어 수정하기',
                    'wordBookTitle': wordBookTitle,
                    'wordBookKey': wordBookKey,
                    'wordBookListKey': wordBookListKey,
                    'targetIndex': 2,
                    'wordKey': card.key,
                  });
                  break;
                case 'delete':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('단어 삭제',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            )),
                        content: Text(
                          '정말로 삭제하시겠어요? 외운 단어라면 체크표시를 해두셔도 좋아요.',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: BODY_TEXT_COLOR,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.red[600],
                              ),
                            ),
                            onPressed: () {
                              ref
                                  .read(wordCardListProvider(wordBookKey)
                                      .notifier)
                                  .removeCard(card.key);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  break;
                default:
              }
              // 여기에 선택된 메뉴 항목에 대한 동작을 추가하세요
            },
            color: Colors.white,
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
                    Text('단어 수정'),
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
                    Text('단어장 이동'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red[300]),
                    SizedBox(width: 8),
                    Text('단어 삭제', style: TextStyle(color: Colors.red[300])),
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
