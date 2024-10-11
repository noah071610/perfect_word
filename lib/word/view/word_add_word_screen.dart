import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_wordbook/common/constant/toast.dart';
import 'package:perfect_wordbook/common/layout/default_layout.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/provider/target_word_book_provider.dart';
import 'package:perfect_wordbook/common/provider/word_card_list_provider.dart';
import 'package:perfect_wordbook/common/utils/utils.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:perfect_wordbook/word/view/word_add_generator.dart';
import 'package:perfect_wordbook/word/view/word_add_manual.dart';

class MemoAddWordScreen extends ConsumerStatefulWidget {
  final int targetIndex;
  final String? wordKey;

  MemoAddWordScreen({
    super.key,
    required this.targetIndex,
    this.wordKey,
  });

  @override
  ConsumerState<MemoAddWordScreen> createState() => _MemoAddWordScreenState();
}

enum AddWordType { extract, generate, manual }

class _MemoAddWordScreenState extends ConsumerState<MemoAddWordScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final TextEditingController aiWordExtractionController =
      TextEditingController();
  final TextEditingController aiWordGenerationController =
      TextEditingController();
  int index = 0;
  bool _isLoading = false;
  List<WordCardModel> generatedCards = [];
  List<bool> selectedCards = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    index = widget.targetIndex;
    controller.index = widget.targetIndex;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onTabTapped(int newIndex) {
    setState(() {
      index = newIndex;
      controller.index = newIndex;
    });
  }

  void addGeneratedWords(AddWordType type, String wordBookKey) async {
    final List<WordCardModel> finalCards = generatedCards
        .where((card) => selectedCards[generatedCards.indexOf(card)])
        .toList();
    await ref
        .read(wordCardListProvider(wordBookKey).notifier)
        .addGeneratedCards(finalCards);

    await ref.read(targetWordBookProvider.notifier).updateCount();

    showCustomToast(context: context, message: context.tr('word_added'));

    context.go('/word_book');
  }

  void generateWords(AddWordType type, String wordBookLanguage) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();

      final bool isExtract = type == AddWordType.extract;
      final String path = isExtract ? 'extract' : 'generate';
      final response = await dio.post(
        '${dotenv.env['SERVER_URL']}/$path?language=${wordBookLanguage}&systemLanguage=${context.locale.toString()}',
        // 'http://localhost:5555/api/perfect-wordbook',
        data: {
          'userText': isExtract
              ? aiWordExtractionController.text
              : aiWordGenerationController.text
        },
      );

      if (response.data != null) {
        final Map<String, dynamic> jsonData = json.decode(response.data);
        final List<dynamic> wordsData = jsonData['words'];

        setState(() {
          generatedCards = wordsData
              .map((e) => WordCardModel(
                    key: generateRandomKey(),
                    word: (e['word'] as String).replaceAll('_', ' '),
                    meaning: e['meaning'] as String,
                    pronounce: '',
                    format: CardFormat.unchecked,
                    createdAt: DateTime.now(),
                  ))
              .toList();
          selectedCards = List.generate(wordsData.length, (int index) => true);
        });
      } else {
        showCustomToast(
            context: context, message: context.tr('ai_word_extraction_failed'));
      }
    } catch (e) {
      showCustomToast(
          context: context, message: context.tr('ai_word_processing_error'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordBook = ref.watch(targetWordBookProvider);
    return DefaultLayout(
      title: widget.wordKey == null
          ? context.tr('add_word')
          : context.tr('edit_word'),
      bottomNavigationBar: widget.wordKey == null
          ? BottomNavigationBar(
              currentIndex: index,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: TextStyle(fontSize: 12),
              unselectedLabelStyle: TextStyle(fontSize: 12),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome),
                  label: context.tr('ai_word_extraction'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.psychology),
                  label: context.tr('ai_context_word_generation'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: context.tr('manual_input'),
                ),
              ],
            )
          : null,
      child: TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          AIWordForm(
            title: context.tr('ai_word_extraction_title'),
            description: context.tr('ai_word_extraction_description'),
            hintText: context.tr('ai_word_extraction_hint'),
            controller: aiWordExtractionController,
            wordBookKey: wordBook.wordBookKey,
            wordLanguage: wordBook.wordBookLanguage,
            generateWords: () {
              generateWords(AddWordType.extract, wordBook.wordBookLanguage);
            },
            addGeneratedWords: () {
              addGeneratedWords(AddWordType.extract, wordBook.wordBookKey);
            },
            isLoading: _isLoading,
            generatedCards: generatedCards,
            selectedCards: selectedCards,
          ),
          AIWordForm(
            title: context.tr('ai_context_word_generation_title'),
            description: context.tr('ai_context_word_generation_description'),
            hintText: context.tr('ai_context_word_generation_hint'),
            controller: aiWordGenerationController,
            wordBookKey: wordBook.wordBookKey,
            wordLanguage: wordBook.wordBookLanguage,
            generateWords: () {
              generateWords(AddWordType.generate, wordBook.wordBookLanguage);
            },
            addGeneratedWords: () {
              addGeneratedWords(AddWordType.extract, wordBook.wordBookKey);
            },
            isLoading: _isLoading,
            generatedCards: generatedCards,
            selectedCards: selectedCards,
          ),
          ManualInputForm(
            wordKey: widget.wordKey,
            context: context,
          ),
        ],
      ),
    );
  }
}
