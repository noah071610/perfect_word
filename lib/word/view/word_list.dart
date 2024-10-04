import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';
import 'package:perfect_memo/common/model/word_filter_model.dart';
import 'package:perfect_memo/common/provider/word_filter_provider.dart';

import 'package:perfect_memo/word/view/word_list_content.dart';

class WordList extends ConsumerStatefulWidget {
  const WordList({
    Key? key,
    required this.wordBookKey,
    required this.wordBookListKey,
    required this.wordBookTitle,
    required this.cards,
  }) : super(key: key);

  final String wordBookKey;
  final String wordBookListKey;
  final String wordBookTitle;
  final List<WordCardModel> cards;

  @override
  _WordListState createState() => _WordListState();
}

class _WordListState extends ConsumerState<WordList> {
  Map<String, bool> localHideStates = {};

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(wordFilterProvider);

    return widget.cards.isEmpty
        ? SliverToBoxAdapter(child: SizedBox())
        : SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final card = widget.cards[index];
                  final isLocallyHidden = localHideStates[card.key] ?? false;
                  return Column(
                    children: [
                      Container(
                        key: ValueKey(card.key),
                        child: Stack(
                          children: [
                            CardMainContent(
                              onTap: () {
                                setState(() {
                                  localHideStates[card.key] = !isLocallyHidden;
                                });
                              },
                              card: card,
                              index: index,
                              hideMeaning: isLocallyHidden
                                  ? false
                                  : CardMaskingType.meaning ==
                                      filter.maskingType,
                              hideWord: isLocallyHidden
                                  ? false
                                  : CardMaskingType.word == filter.maskingType,
                            ),
                            CardIcons(
                              card: card,
                              wordBookKey: widget.wordBookKey,
                              wordBookListKey: widget.wordBookListKey,
                              wordBookTitle: widget.wordBookTitle,
                            ),
                          ],
                        ),
                      ),
                      if (index < widget.cards.length - 1)
                        Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                    ],
                  );
                },
                childCount: widget.cards.length,
              ),
            ),
          );
  }
}
