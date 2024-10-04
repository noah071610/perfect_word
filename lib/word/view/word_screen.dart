import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/constant/toast.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:perfect_memo/common/layout/sliver_layout.dart';
import 'package:perfect_memo/common/model/word_filter_model.dart';
import 'package:perfect_memo/common/provider/word_card_list_provider.dart';
import 'package:perfect_memo/common/provider/word_book_list_provider.dart';
import 'package:perfect_memo/common/provider/word_filter_provider.dart';
import 'package:perfect_memo/common/widgets/custom_dialog.dart';
import 'package:perfect_memo/common/widgets/floating_label_text_field.dart';
import 'package:perfect_memo/word/view/word_card.dart';
import 'package:perfect_memo/word/view/word_grid.dart';
import 'package:perfect_memo/word/view/word_list.dart';
import 'package:perfect_memo/word/view/word_filter.dart';

class WordScreen extends ConsumerStatefulWidget {
  final String wordBookListKey;
  final String wordBookKey;
  final String wordBookTitle;

  const WordScreen({
    super.key,
    required this.wordBookKey,
    required this.wordBookListKey,
    required this.wordBookTitle,
  });

  @override
  _WordScreenState createState() => _WordScreenState();
}

class _WordScreenState extends ConsumerState<WordScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _isLoading = true;
    });
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      ref.read(searchQueryProvider.notifier).state = searchController.text;
      setState(() {
        _isLoading = false;
      });
    });
  }

// COMP: 아이콘
  List<Widget> _buildActions() {
    return [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => _navigateToAddWord(2),
      ),
      IconButton(
        icon: const Icon(Icons.auto_fix_high),
        onPressed: () => _navigateToAddWord(0),
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.repeat),
        onPressed: _shuffleCards,
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.sort_down),
        onPressed: _showFilterSheet,
      ),
    ];
  }

  void _navigateToAddWord(int targetIndex) {
    context.go(
      '/word/${widget.wordBookListKey}/${widget.wordBookKey}/add_word',
      extra: {'title': '단어 입력하기', 'targetIndex': targetIndex},
    );
  }

  void _shuffleCards() {
    final cardListNotifier =
        ref.read(wordCardListProvider(widget.wordBookKey).notifier);
    cardListNotifier.shuffleCards();
  }

// COMP: 필터 시트 랜더링 헬퍼
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => FilterSheet(),
    );
  }

  void _showTitleChangeDialog(
      BuildContext context, WidgetRef ref, String title) {
    final TextEditingController titleController =
        TextEditingController(text: title);
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: '💬 타이틀 변경',
          btnText: '타이틀 변경하기',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.0),
              FloatingLabelTextField(
                label: '타이틀명',
                controller: titleController,
              ),
              SizedBox(height: 20.0),
            ],
          ),
          onTap: () {
            ref.read(wordBookListProvider.notifier).changeWordBookTitle(
                widget.wordBookListKey,
                widget.wordBookKey,
                titleController.text);
            showCustomToast(context, '타이틀이 변경되었어요!');
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(filteredWordCardListProvider(widget.wordBookKey));
    final filter = ref.watch(wordFilterProvider);

    return filter.layoutType == CardLayoutType.list
        ? SliverLayout(
            title: widget.wordBookTitle,
            onClickTitle: () =>
                {_showTitleChangeDialog(context, ref, widget.wordBookTitle)},
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: '검색어를 입력하세요',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isLoading)
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(BORDER_COLOR),
                    ),
                  if (!_isLoading)
                    SizedBox(
                      height: 4.0,
                    )
                ],
              ),
            ),
            slivers: [
              WordList(
                wordBookKey: widget.wordBookKey,
                wordBookListKey: widget.wordBookListKey,
                wordBookTitle: widget.wordBookTitle,
                cards: cards,
              ),
            ],
            actions: _buildActions(),
          )
        : DefaultLayout(
            title: widget.wordBookTitle,
            onClickTitle: () =>
                {_showTitleChangeDialog(context, ref, widget.wordBookTitle)},
            actions: _buildActions(),
            child: filter.layoutType == CardLayoutType.grid
                ? WordGrid(
                    cards: cards,
                    wordBookKey: widget.wordBookKey,
                  )
                : cards.isNotEmpty
                    ? WordSliderCard(
                        cards: cards,
                        wordBookKey: widget.wordBookKey,
                        isMaskingWord:
                            filter.maskingType == CardMaskingType.word,
                      )
                    : Center(
                        child: Text('단어가 없습니다'),
                      ),
          );
  }
}
