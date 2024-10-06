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
import 'package:perfect_memo/common/provider/target_word_book_provider.dart';
import 'package:perfect_memo/common/provider/word_card_list_provider.dart';
import 'package:perfect_memo/common/provider/word_filter_provider.dart';
import 'package:perfect_memo/common/widgets/custom_dialog.dart';
import 'package:perfect_memo/common/widgets/floating_label_text_field.dart';
import 'package:perfect_memo/word/view/word_card.dart';
import 'package:perfect_memo/word/view/word_grid.dart';
import 'package:perfect_memo/word/view/word_list.dart';
import 'package:perfect_memo/word/view/word_filter.dart';
import 'package:easy_localization/easy_localization.dart';

class WordScreen extends ConsumerStatefulWidget {
  const WordScreen({
    super.key,
  });

  @override
  _WordScreenState createState() => _WordScreenState();
}

class _WordScreenState extends ConsumerState<WordScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  bool _isFocused = false; // 포커스 상태를 추적하기 위한 변수 추가

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

// COMP: 앱바 아이콘
  List<Widget> _buildActions(bool isSystemWordBook, String wordBookKey) {
    return [
      if (!isSystemWordBook)
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _navigateToAddWord(2),
        ),
      if (!isSystemWordBook)
        IconButton(
          icon: const Icon(Icons.auto_fix_high),
          onPressed: () => _navigateToAddWord(0),
        ),
      IconButton(
        icon: const Icon(CupertinoIcons.repeat),
        onPressed: () => {_shuffleCards(wordBookKey)},
      ),
      IconButton(
        icon: const Icon(CupertinoIcons.sort_down),
        onPressed: _showFilterSheet,
      ),
    ];
  }

  void _navigateToAddWord(int targetIndex) {
    context.go(
      '/word_book/add',
      extra: {
        'targetIndex': targetIndex,
      },
    );
  }

  void _shuffleCards(String wordBookKey) {
    final cardListNotifier =
        ref.read(wordCardListProvider(wordBookKey).notifier);
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
          title: context.tr('change_title_dialog'),
          btnText: context.tr('edit'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.0),
              FloatingLabelTextField(
                label: context.tr('title_name'),
                controller: titleController,
              ),
              SizedBox(height: 20.0),
            ],
          ),
          onTap: () {
            ref
                .read(targetWordBookProvider.notifier)
                .updateWordBookTitle(titleController.text);

            showCustomToast(
                context: context, message: context.tr('title_changed_message'));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordBook = ref.watch(targetWordBookProvider);
    final cards = ref.watch(filteredWordCardListProvider(wordBook.wordBookKey));
    final filter = ref.watch(wordFilterProvider);

    final bool isSystemWordBook = wordBook.wordBookKey == 'difficulty' ||
        wordBook.wordBookKey == 'deleted';

    return filter.layoutType == CardLayoutType.list
        ? SliverLayout(
            title: wordBook.wordBookTitle,
            onClickTitle: () => {
              if (!isSystemWordBook)
                _showTitleChangeDialog(context, ref, wordBook.wordBookTitle)
            },
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, top: 5.0, bottom: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                _isFocused = hasFocus;
                              });
                            },
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: context.tr('search_hint'),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        if (_isFocused && searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(CupertinoIcons.clear_circled,
                                color: BODY_TEXT_COLOR),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                              });
                            },
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
                cards: cards,
              ),
            ],
            actions: _buildActions(isSystemWordBook, wordBook.wordBookKey),
          )
        : DefaultLayout(
            title: wordBook.wordBookTitle,
            onClickTitle: () => {
              if (!isSystemWordBook)
                _showTitleChangeDialog(context, ref, wordBook.wordBookTitle)
            },
            actions: _buildActions(isSystemWordBook, wordBook.wordBookKey),
            child: filter.layoutType == CardLayoutType.grid
                ? WordGrid(
                    cards: cards,
                    wordBookKey: wordBook.wordBookKey,
                    isMaskingWord: filter.maskingType == CardMaskingType.word,
                  )
                : cards.isNotEmpty
                    ? WordSliderCard(
                        cards: cards,
                        wordBookKey: wordBook.wordBookKey,
                        isMaskingWord:
                            filter.maskingType == CardMaskingType.word,
                      )
                    : Center(
                        child: Text(context.tr('no_words')),
                      ),
          );
  }
}
