import 'dart:async';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:animated_emoji/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:perfect_memo/common/utils/utils.dart';
import 'package:perfect_memo/create/model/memo_model.dart';
import 'package:perfect_memo/home/provider/memo_list_provider.dart';

enum TextFieldEnum { words, meanings }

class CreateTab extends ConsumerStatefulWidget {
  final String memoKey;
  final String emoji;
  final Color color;

  const CreateTab({
    super.key,
    required this.memoKey,
    required this.emoji,
    required this.color,
  });

  @override
  ConsumerState<CreateTab> createState() => _CreateTabState();
}

class IgnoreShortcutKeysFocusNode extends FocusNode {}

class _CreateTabState extends ConsumerState<CreateTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  List<MemoModel> list = [
    MemoModel(word: '\u200B', meaning: '', key: generateRandomKey())
  ];
  List<List<FocusNode>> focusNodes = [
    [FocusNode(), FocusNode()]
  ];
  List<List<TextEditingController>> textControllers = [
    [TextEditingController(), TextEditingController()]
  ];
  TextEditingController titleController = TextEditingController();

  bool _showError = false;
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  void _onTabTapped(int newIndex) {
    setState(() {
      index = newIndex;
      controller.index = newIndex;
    });
  }

  // void _updateMemo({
  //   required String text,
  //   required TextFieldEnum type,
  //   required MemoModel memo,
  // }) async {
  //   final lines = text.split('\n');
  //   final validLines =
  //       lines.map((line) => line.length > 15 ? line.substring(0, 15) : line);
  //   final validText = validLines.join('\n');

  //   if (validText != text) {
  //     setState(() {
  //       wordsController.text = validText;
  //       wordsController.selection = TextSelection.fromPosition(
  //         TextPosition(offset: validText.length),
  //       );
  //     });
  //     _showErrorMessage();
  //   }

  //   final updatedMemo = memo.copyWith(
  //     memoKey: widget.memoKey,
  //     words: TextFieldEnum.words == type ? validText : null,
  //     meanings: TextFieldEnum.meanings == type ? validText : null,
  //   );

  //   await ref.read(memoListProvider.notifier).updateSelectedMemo(
  //         widget.memoKey,
  //         updatedMemo,
  //       );
  // }

  void _showErrorMessage() {
    setState(() {
      _showError = true;
    });
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showError = false;
      });
    });
  }

  void _removeInputPair(int index) {
    setState(() {
      focusNodes.removeAt(index);
      list.removeAt(index);
      if (index >= 1)
        FocusScope.of(context).requestFocus(focusNodes[index - 1][0]);
    });
  }

  void _addNewInput() {
    setState(() {
      list.add(
          MemoModel(word: '\u200B', meaning: '', key: generateRandomKey()));
      focusNodes.add([FocusNode(), FocusNode()]);
      textControllers.add([TextEditingController(), TextEditingController()]);
    });
  }

  Widget _buildInputRow(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    TextField(
                      focusNode: focusNodes[index][0],
                      controller: textControllers[index][0],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        fillColor: Colors.transparent,
                      ),
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLength: 20,
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) =>
                          null,
                      onChanged: (value) {
                        setState(() {});
                        if (textControllers[index][0].text.isEmpty) {
                          _removeInputPair(index);
                          return;
                        }
                        if (value.length > 19) {
                          _showErrorMessage();
                        }
                        if (index + 1 == list.length) {
                          _addNewInput();
                        }
                        list[index] = list[index].copyWith(word: value);
                      },
                      onSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index][1]);
                      },
                    ),
                    if (textControllers[index][0].text == '\u200B')
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index][0]);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '단어 입력',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 6.0),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_double_arrow_right_outlined,
                        color: Colors.grey,
                      ),
                    )),
              ),
              Expanded(
                child: TextField(
                  controller: textControllers[index][1],
                  focusNode: focusNodes[index][1],
                  decoration: InputDecoration(
                    hintText: '뜻 입력',
                    hintStyle: TextStyle(color: Colors.black45),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLength: 20,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  onChanged: (value) {
                    if (value.length > 19) {
                      _showErrorMessage();
                    }

                    if (index + 1 == list.length) {
                      _addNewInput();
                    }
                    list[index] = list[index].copyWith(meaning: value);
                  },
                  onSubmitted: (_) {
                    if (index + 1 < focusNodes.length) {
                      FocusScope.of(context)
                          .requestFocus(focusNodes[index + 1][0]);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '메모 수정하기',
      bottomNavigationBar: CustomBottomNavBar(
        index: index,
        onTabTapped: _onTabTapped,
        onCreatePressed: () {},
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            color: widget.color,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      widget.emoji,
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    controller: titleController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '타이틀 입력',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLength: 20,
                    maxLines: 1,
                    minLines: 1,
                  ))
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView.separated(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final memo = list[index];
                textControllers[index][0].text = memo.word;
                textControllers[index][1].text = memo.meaning;
                return _buildInputRow(index);
              },
              separatorBuilder: (_, index) => SizedBox(
                height: 13.0,
              ),
            ),
          )),
          if (_showError)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.red.withOpacity(0.8),
                  child: Text(
                    '최대 20자까지 입력 가능합니다.',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTabTapped;
  final VoidCallback onCreatePressed;

  const CustomBottomNavBar({
    Key? key,
    required this.index,
    required this.onTabTapped,
    required this.onCreatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onTabTapped(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_note, // 여기 ,
                          color: index == 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                      Text('단어 작성',
                          style: TextStyle(
                              color: index == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onTabTapped(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.translate, // 여기,
                          color: index == 1
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                      Text('의미 작성',
                          style: TextStyle(
                              color: index == 1
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
