import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/provider/word_book_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:perfect_wordbook/home/view/word_book_list_card.dart';

/// COMP: 리스트 카드
class WordBookList extends ConsumerWidget {
  const WordBookList({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final wordBookListArr = ref.watch(wordBookListProvider);
    return Padding(
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
    );
  }
}
