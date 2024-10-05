import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/constant/toast.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';
import 'package:perfect_memo/common/provider/word_card_list_provider.dart';
import 'package:perfect_memo/common/provider/word_book_list_provider.dart';
import 'package:perfect_memo/common/utils/utils.dart';
import 'package:perfect_memo/common/widgets/custom_button.dart';
import 'package:perfect_memo/common/widgets/floating_label_text_field.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class MemoAddWordScreen extends ConsumerStatefulWidget {
  final String wordBookKey;
  final String wordBookListKey;
  final String wordBookTitle;
  final String wordBookLanguage;
  final int targetIndex;
  final String? wordKey;

  MemoAddWordScreen({
    super.key,
    required this.wordBookListKey,
    required this.wordBookKey,
    required this.wordBookTitle,
    required this.wordBookLanguage,
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

  void addGeneratedWords(AddWordType type) async {
    final List<WordCardModel> finalCards = generatedCards
        .where((card) => selectedCards[generatedCards.indexOf(card)])
        .toList();
    await ref
        .read(wordCardListProvider(widget.wordBookKey).notifier)
        .addGeneratedCards(finalCards);

    showCustomToast(context, '단어를 추가했어요! 🚀');

    context.go('/word_book', extra: {
      'wordBookListKey': widget.wordBookListKey,
      'wordBookKey': widget.wordBookKey,
      'wordBookTitle': widget.wordBookTitle,
      'wordBookLanguage': widget.wordBookLanguage,
    });
  }

  void generateWords(AddWordType type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();

      final bool isExtract = type == AddWordType.extract;
      final String path = isExtract ? 'extract' : 'generate';
      final response = await dio.post(
        'http://localhost:5555/api/vote/$path?language=${widget.wordBookLanguage}',
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
        showCustomToast(context, 'AI 단어 추출에 실패했습니다.');
      }
    } catch (e) {
      showCustomToast(context, 'AI 단어 처리 중 오류가 발생했습니다.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: widget.wordKey == null ? '단어 추가하기' : '단어 수정하기',
      bottomNavigationBar: widget.wordKey == null
          ? BottomNavigationBar(
              currentIndex: index,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: TextStyle(fontSize: 12),
              unselectedLabelStyle: TextStyle(fontSize: 12),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome),
                  label: 'AI 단어 추출',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.psychology),
                  label: 'AI 문맥 단어 생성',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: '수동 입력',
                ),
              ],
            )
          : null,
      child: TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          AIWordForm(
            title: 'AI 단어 추출',
            description: 'AI를 사용하여 텍스트에서 단어를 추출합니다.',
            hintText: '텍스트를 입력하세요 (예: 노래 가사, 블로그 글...)',
            controller: aiWordExtractionController,
            wordBookKey: widget.wordBookKey,
            generateWords: () {
              generateWords(AddWordType.extract);
            },
            addGeneratedWords: () {
              addGeneratedWords(AddWordType.extract);
            },
            isLoading: _isLoading,
            generatedCards: generatedCards,
            selectedCards: selectedCards,
          ),
          AIWordForm(
            title: 'AI 문맥 단어 생성',
            description: 'AI를 사용하여 문맥에 맞는 단어를 생성합니다.',
            hintText: '문맥을 입력하세요 (예: 뉴욕 파스타 레스토랑에서 손님으로 대화 할 때 유용한 단어를 알려줘)',
            controller: aiWordGenerationController,
            wordBookKey: widget.wordBookKey,
            generateWords: () {
              generateWords(AddWordType.generate);
            },
            addGeneratedWords: () {
              addGeneratedWords(AddWordType.extract);
            },
            isLoading: _isLoading,
            generatedCards: generatedCards,
            selectedCards: selectedCards,
          ),
          ManualInputForm(
            wordBookKey: widget.wordBookKey,
            wordBookListKey: widget.wordBookListKey,
            wordKey: widget.wordKey,
            wordBookTitle: widget.wordBookTitle,
            wordBookLanguage: widget.wordBookLanguage,
            context: context,
          ),
        ],
      ),
    );
  }
}

class ManualInputForm extends ConsumerWidget {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();
  final TextEditingController pronounceController = TextEditingController();
  final FocusNode wordFocus = FocusNode();
  final FocusNode meaningFocus = FocusNode();
  final FocusNode pronounceFocus = FocusNode();
  final BuildContext context;
  final String wordBookKey;
  final String wordBookListKey;
  final String wordBookTitle;
  final String wordBookLanguage;
  final String? wordKey;

  ManualInputForm({
    Key? key,
    required this.wordBookListKey,
    required this.wordBookKey,
    required this.wordBookTitle,
    required this.wordBookLanguage,
    required this.context,
    this.wordKey,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onSubmit(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      if (wordKey != null) {
        // 기존 단어 카드 업데이트
        ref.read(wordCardListProvider(wordBookKey).notifier).updateCard(
              wordKey!,
              word: wordController.text,
              meaning: meaningController.text,
              pronounce: pronounceController.text,
            );

        showCustomToast(context, '변경 완료했어요 💫');
        context.go('/word_book', extra: {
          'wordBookListKey': wordBookListKey,
          'wordBookKey': wordBookKey,
          'wordBookTitle': wordBookTitle,
          'wordBookLanguage': wordBookLanguage,
        });
      } else {
        // 새 단어 카드 추가
        ref.read(wordCardListProvider(wordBookKey).notifier).addCard(
              wordController.text,
              meaningController.text,
              pronounceController.text,
              'default',
            );

        wordController.text = '';
        meaningController.text = '';
        pronounceController.text = '';
        wordFocus.requestFocus();
        showCustomToast(context, '단어를 추가했어요 🚀');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // wordKey가 있을 경우 해당 단어 카드 정보를 가져옵니다.
    if (wordKey != null) {
      final wordCards = ref.read(wordCardListProvider(wordBookKey));
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
              label: '단어 입력',
              autofocus: true,
              controller: wordController,
              focusNode: wordFocus,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(meaningFocus);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '단어를 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            FloatingLabelTextField(
              label: '의미 입력',
              controller: meaningController,
              focusNode: meaningFocus,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(pronounceFocus);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '의미를 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            FloatingLabelTextField(
              label: '발음 입력 (옵션)',
              controller: pronounceController,
              focusNode: pronounceFocus,
              onFieldSubmitted: (_) => {
                if (wordController.text.isNotEmpty &&
                    meaningController.text.isNotEmpty)
                  {onSubmit(ref)}
              },
            ),
            SizedBox(height: 30),
            CustomButton(onSubmit: () => {onSubmit(ref)}, text: '단어 입력하기'),
          ],
        ),
      ),
    );
  }
}

// COMP: AI WORD
class AIWordForm extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final String hintText;
  final String wordBookKey;
  final VoidCallback generateWords;
  final VoidCallback addGeneratedWords;
  final TextEditingController controller;
  final bool isLoading;
  final List<WordCardModel> generatedCards;
  final List<bool> selectedCards;

  AIWordForm({
    Key? key,
    required this.title,
    required this.description,
    required this.hintText,
    required this.wordBookKey,
    required this.generateWords,
    required this.controller,
    required this.isLoading,
    required this.generatedCards,
    required this.selectedCards,
    required this.addGeneratedWords,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AIWordFormState();
}

class _AIWordFormState extends ConsumerState<AIWordForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _textFieldKey =
      GlobalKey<FormFieldState<String>>();

  void _validateAndSubmit(BuildContext context) {
    if (_textFieldKey.currentState!.validate()) {
      widget.generateWords();
    } else {
      showCustomToast(context, '텍스트를 입력해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 15,
                color: BODY_TEXT_COLOR,
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            SizedBox(height: 10),
            Expanded(
              child: (widget.generatedCards.isEmpty ||
                      widget.selectedCards.isEmpty)
                  ? TextFormField(
                      key: _textFieldKey,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                        border: InputBorder.none,
                        counterText: null,
                      ),
                      maxLines: null,
                      expands: true,
                      maxLength: 1000,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '텍스트를 입력해주세요.';
                        }
                        return null;
                      },
                      buildCounter: (
                        BuildContext context, {
                        required int currentLength,
                        required int? maxLength,
                        required bool isFocused,
                      }) {
                        return Text(
                          '$currentLength / $maxLength',
                          style: TextStyle(
                            fontSize: 14,
                            color: BODY_TEXT_COLOR,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: widget.generatedCards.length,
                      itemBuilder: (context, index) {
                        final card = widget.generatedCards[index];
                        return Row(
                          children: [
                            Expanded(
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        card.word,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              widget.selectedCards[index]
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough,
                                          color: widget.selectedCards[index]
                                              ? Colors.black
                                              : BODY_TEXT_COLOR,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        card.meaning,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: BODY_TEXT_COLOR,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                widget.selectedCards[index]
                                    ? CupertinoIcons.delete
                                    : CupertinoIcons.plus_app,
                                size: 20,
                                color: widget.selectedCards[index]
                                    ? Colors.red[400]
                                    : Colors.green,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.selectedCards[index] =
                                      !widget.selectedCards[index];
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
            ),
            SizedBox(height: 30),
            CustomButton(
              onSubmit: widget.generatedCards.isEmpty
                  ? () => _validateAndSubmit(context)
                  : widget.addGeneratedWords,
              text: widget.generatedCards.isEmpty ? '자동 생성하기' : '단어장에 추가하기',
              isLoading: widget.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
