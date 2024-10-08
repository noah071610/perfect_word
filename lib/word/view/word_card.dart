import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/provider/target_word_book_provider.dart';
import 'package:perfect_wordbook/common/provider/word_card_list_provider.dart';
import 'package:perfect_wordbook/common/provider/word_filter_provider.dart';
import 'package:perfect_wordbook/common/theme/custom_colors.dart';
import 'package:perfect_wordbook/common/utils/utils.dart';

class WordSliderCard extends ConsumerStatefulWidget {
  final List<WordCardModel> cards;
  final String wordBookKey;
  final bool isMaskingWord;

  const WordSliderCard({
    Key? key,
    required this.cards,
    required this.wordBookKey,
    required this.isMaskingWord,
  }) : super(key: key);

  @override
  ConsumerState createState() => _WordSliderCardState();
}

class _WordSliderCardState extends ConsumerState<WordSliderCard>
    with TickerProviderStateMixin {
  late CardSwiperController _cardController = CardSwiperController();
  Map<int, bool> revealedStates = {};
  bool isPlaying = false;
  late AnimationController _progressController;
  Timer? _autoPlayTimer;
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.cards.length; i++) {
      revealedStates[i] = false;
    }
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _cardController.swipe(CardSwiperDirection.right);
          _progressController.reset();
          if (isPlaying) {
            _progressController.forward();
          }
        }
      });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _autoPlayTimer?.cancel();
    _cardController.dispose();
    super.dispose();
  }

  Widget _buildCard(WordCardModel card, int index) {
    final CustomColors? theme = Theme.of(context).extension<CustomColors>();

    final fontSize = ref.watch(wordFilterProvider).fontSize;

    return GestureDetector(
      onTap: () {
        if (isPlaying) _toggleAutoPlay(forceStop: true);
        setState(() {
          revealedStates[index] = !(revealedStates[index] ?? false);
        });
      },
      child: Card(
        borderOnForeground: true,
        elevation: 8,
        shadowColor: theme?.buttonBackground,
        child: Center(
          child: revealedStates[index] ?? false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.word,
                      style: TextStyle(
                          fontSize: fontSize['word']! + 3,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (card.pronounce.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(height: 2),
                          Text(
                            '[${card.pronounce}]',
                            style: TextStyle(
                                fontSize: fontSize['pronounce']! + 4,
                                color: BODY_TEXT_COLOR),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    SizedBox(height: 16),
                    Text(
                      card.meaning,
                      style: TextStyle(
                          fontSize: fontSize['meaning']! + 2,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Text(
                  widget.isMaskingWord ? card.meaning : card.word,
                  style: TextStyle(
                      fontSize: fontSize['word']! + 3,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  void _toggleAutoPlay({bool? forceStop}) {
    setState(() {
      isPlaying = forceStop == true ? false : !isPlaying;
      if (forceStop == true) {
        _progressController.stop();
      } else {
        if (isPlaying) {
          _progressController.forward();
        } else {
          _progressController.stop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            return isPlaying
                ? LinearProgressIndicator(
                    value: _progressController.value,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(BUTTON_TEXT_COLOR),
                  )
                : SizedBox(
                    height: 5,
                  );
          },
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: CardSwiper(
                controller: _cardController,
                cardsCount: widget.cards.length,
                onSwipe: (previousIndex, currentIndex, direction) {
                  setState(() {
                    curIndex = currentIndex ?? 0;
                  });
                  return true; // 재생 중이 아닐 때 스와이프 허용
                },
                numberOfCardsDisplayed:
                    widget.cards.length > 2 ? 3 : widget.cards.length,
                backCardOffset: Offset(0, 40),
                padding: EdgeInsets.all(24),
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) =>
                        _buildCard(widget.cards[index], index),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.left_chevron),
                onPressed: () => {
                  _cardController.undo(),
                  if (curIndex >= 1)
                    setState(() {
                      curIndex -= 1;
                    })
                },
                color: BODY_TEXT_COLOR,
              ),
              IconButton(
                icon: Icon(
                  isPlaying
                      ? CupertinoIcons.pause_fill
                      : CupertinoIcons.play_fill,
                ),
                onPressed: _toggleAutoPlay,
                color: isPlaying ? Colors.redAccent : BODY_TEXT_COLOR,
              ),
              IconButton(
                icon: getCardFormatIcon(format: widget.cards[curIndex].format),
                onPressed: () async {
                  final newFormat =
                      getCardNextFormat(widget.cards[curIndex].format);
                  await ref
                      .read(wordCardListProvider(widget.wordBookKey).notifier)
                      .updateCard(widget.cards[curIndex].key,
                          format: newFormat);
                  await ref.read(targetWordBookProvider.notifier).updateCount();
                },
              ),
              IconButton(
                icon: Icon(CupertinoIcons.right_chevron),
                onPressed: () => {
                  _cardController.swipe(CardSwiperDirection.right),
                  setState(() {
                    curIndex += 1;
                  })
                },
                color: BODY_TEXT_COLOR,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
