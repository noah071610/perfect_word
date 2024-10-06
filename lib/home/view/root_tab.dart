import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/constant/toast.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:perfect_memo/common/provider/word_book_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:perfect_memo/common/utils/utils.dart';
import 'package:perfect_memo/common/widgets/custom_dialog.dart';
import 'package:perfect_memo/common/widgets/floating_label_text_field.dart';
import 'package:perfect_memo/home/view/setting_screen.dart';
import 'package:perfect_memo/home/view/word_book_list_card.dart';

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
    controller = TabController(length: 2, vsync: this); // 4개의 탭으로 변경
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
          btnText: context.tr('create_category'),
          title: context.tr('new_category_title'),
          child: FloatingLabelTextField(
            label: context.tr('category_title'),
            controller: titleController,
          ),
          onTap: () async {
            if (titleController.text.isEmpty) {
              showCustomToast(
                  context: context,
                  message: context.tr('enter_title'),
                  isError: true);
              return;
            }
            final wordBookListKey = generateRandomKey();
            await ref
                .read(wordBookListProvider.notifier)
                .addWordBookList(wordBookListKey, titleController.text);
            showCustomToast(
                context: context, message: context.tr('new_category_created'));
            titleController.text = '';
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
      title: index == 1 ? context.tr('setting') : context.tr('main_page'),
      centerTitle: index == 1 ? true : false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: context.tr('word_book')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: context.tr('setting')),
        ],
      ),
      actions: index == 1
          ? null
          : [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateWordBookListModal(context),
              ),
            ],
      child: TabBarView(
        controller: controller,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: wordBookListArr.length,
              itemBuilder: (context, index) {
                final wordBookList = wordBookListArr[index];
                return WordBookListCard(
                    wordBookList: wordBookList,
                    isOnlyOneList: wordBookListArr.length <= 1,
                    isSystemWordBookListCard: wordBookList.key == 'supplement');
              },
            ),
          ),
          SettingScreen(),
        ],
      ),
    );
  }
}
