import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';
import 'package:perfect_memo/common/provider/word_card_list_provider.dart';
import 'package:perfect_memo/common/utils/utils.dart';

class WordGrid extends ConsumerWidget {
  final List<WordCardModel> cards;
  final String wordBookKey;

  const WordGrid({
    Key? key,
    required this.cards,
    required this.wordBookKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: '단어'),
              Tab(text: '의미'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // 첫 번째 탭: 단어와 발음
                ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            card.word,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          if (card.pronounce.isNotEmpty)
                            Row(
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  '[${card.pronounce}]',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: BODY_TEXT_COLOR),
                                )
                              ],
                            ),
                          IconButton(
                            iconSize: 20,
                            icon: getCardFormatIcon(card.format),
                            onPressed: () {
                              final newFormat = getCardNextFormat(card.format);
                              ref
                                  .read(wordCardListProvider(wordBookKey)
                                      .notifier)
                                  .updateCard(card.key, format: newFormat);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // 두 번째 탭: 의미
                ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            card.meaning,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: getCardFormatIcon(card.format),
                            onPressed: () {
                              final newFormat = getCardNextFormat(card.format);
                              ref
                                  .read(wordCardListProvider(wordBookKey)
                                      .notifier)
                                  .updateCard(card.key, format: newFormat);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
