import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_memo/common/provider/word_book_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:perfect_memo/common/model/word_book_list_model.dart';
import 'package:perfect_memo/common/model/word_book_model.dart';
import 'package:perfect_memo/common/utils/utils.dart';
import 'package:perfect_memo/common/widgets/custom_dialog.dart';
import 'package:perfect_memo/common/widgets/floating_label_text_field.dart';

class RootTab extends ConsumerStatefulWidget {
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this); // 4개의 탭으로 변경
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

  void _showCreateWordBookListModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          btnText: '카테고리 만들기',
          title: '🔖 새 카테고리 만들기',
          child: FloatingLabelTextField(
            label: '카테고리 제목',
            controller: titleController,
          ),
          onTap: () async {
            final wordBookListKey = generateRandomKey();
            await ref
                .read(wordBookListProvider.notifier)
                .addWordBookList(wordBookListKey, titleController.text);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordBookListArr = ref.watch(wordBookListProvider);

    return DefaultLayout(
      title: '메인 페이지',
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '단어장'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: '퀴즈'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showCreateWordBookListModal(context),
        ),
      ],
      child: TabBarView(
        controller: controller,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: wordBookListArr.length,
            itemBuilder: (context, index) {
              final wordBookList = wordBookListArr[index];
              return WordBookListCard(wordBookList: wordBookList);
            },
          ),
          Center(child: Text('퀴즈')), // 퀴즈 탭
          Center(child: Text('설정')), // 설정 탭
        ],
      ),
    );
  }
}

/// COMP: 리스트 카드
class WordBookListCard extends ConsumerStatefulWidget {
  final WordBookListModel wordBookList;

  const WordBookListCard({Key? key, required this.wordBookList})
      : super(key: key);

  @override
  ConsumerState<WordBookListCard> createState() => _WordBookListCardState();
}

class _WordBookListCardState extends ConsumerState<WordBookListCard> {
  bool _isExpanded = false;
  final TextEditingController titleController = TextEditingController();

  /// COMP: 모달
  void _showCreateWordBookModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          btnText: '단어장 만들기',
          title: '📖 새 단어장 만들기',
          child: FloatingLabelTextField(
            label: '단어장 제목',
            controller: titleController,
          ),
          onTap: () {
            final wordBookKey = generateRandomKey();
            ref.read(wordBookListProvider.notifier).addWordBook(
                widget.wordBookList.key, wordBookKey, titleController.text);
            Navigator.of(context).pop();
            context.go('/word_book', extra: {
              'wordBookListKey': widget.wordBookList.key,
              'wordBookKey': wordBookKey,
              'wordBookTitle': titleController.text,
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
      elevation: 0, // 그림자 제거
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none, // 테두리 제거
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 0, 8, 0), // 오른쪽 패딩을 줄임
            tileColor: PRIMARY_SOFT_COLOR, // 베이지 색상
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: BORDER_COLOR,
                  width: 1,
                )),

            leading: Icon(CupertinoIcons.book, color: BUTTON_TEXT_COLOR),
            title: Text(
              widget.wordBookList.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _showCreateWordBookModal(context);
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 8),
                Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (widget.wordBookList.bookList.isEmpty)
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                '아직 단어장이 없어요 🥺',
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 16,
                ),
              ),
            ),
          AnimatedCrossFade(
            firstChild: Container(height: 0),
            secondChild: _buildExpandedList(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 150),
          ),
        ],
      ),
    );
  }

// COMP: 단어장 목록
  Widget _buildExpandedList() {
    return Column(
      children: widget.wordBookList.bookList.asMap().entries.map((entry) {
        final int index = entry.key;
        final WordBookModel book = entry.value;
        final bool isLastItem =
            index == widget.wordBookList.bookList.length - 1;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: isLastItem
                  ? BorderSide.none
                  : BorderSide(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
            ),
          ),
          child: ListTile(
            leading: Icon(CupertinoIcons.bookmark, color: Colors.grey),
            title: Text(book.title),
            onTap: () {
              context.go('/word_book', extra: {
                'wordBookListKey': widget.wordBookList.key,
                'wordBookKey': book.key,
                'wordBookTitle': book.title,
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
