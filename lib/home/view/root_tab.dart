import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:perfect_memo/common/constant/data.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_memo/common/utils/utils.dart';
import 'package:perfect_memo/create/provider/memo_provider.dart';
import 'package:perfect_memo/common/hive/hive.dart';
import 'package:perfect_memo/create/model/memo_model.dart';
import 'package:perfect_memo/home/provider/memo_list_provider.dart';

class RootTab extends ConsumerStatefulWidget {
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '메인 페이지',
      bottomNavigationBar: CustomBottomNavBar(
        index: index,
        onTabTapped: _onTabTapped,
        onCreatePressed: () {
          // final memo = ref
          //     .read(memoListProvider.notifier)
          //     .addNewMemo(generateRandomKey());

          context.go(Uri(path: '/create', queryParameters: {
            'memoKey': generateRandomKey(),
          }).toString());
        },
      ),
      child: TabBarView(
        controller: controller,
        children: [
          Center(child: Text('설정')), // 홈 탭에 MemoList 위젯 추가
          Center(child: Text('설정')),
          Center(child: Text('설정')),
        ],
      ),
    );
  }
}

// class MemoList extends ConsumerWidget {
//   const MemoList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final memos = ref.watch(memoListProvider);

//     if (memos.isEmpty) {
//       return Center(child: Text('데이터가 없습니다'));
//     }

//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: ListView.builder(
//         itemCount: memos.length,
//         itemBuilder: (context, index) {
//           final memo = memos[index];
//           final randomEmoji = emojis[index % emojis.length];
//           final pastelColor = pastelColors[index % pastelColors.length];

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//             child: GestureDetector(
//               onTap: () => context.go(Uri(
//                 path: '/create',
//                 queryParameters: {
//                   'memoKey': memo.memoKey,
//                 },
//               ).toString()),
//               child: Card(
//                 color: pastelColor,
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   leading: Text(
//                     randomEmoji,
//                     style: TextStyle(fontSize: 24),
//                   ),
//                   title: Text(
//                     memo.words,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

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
                      Icon(Icons.home,
                          color: index == 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                      Text('홈',
                          style: TextStyle(
                              color: index == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 80,
              ), // 중앙 버튼을 위한 공간
              Expanded(
                child: InkWell(
                  onTap: () => onTabTapped(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings,
                          color: index == 1
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                      Text('설정',
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
        Positioned(
          top: -20,
          width: 65.0,
          height: 65.0,
          child: FloatingActionButton(
            onPressed: onCreatePressed,
            child: Icon(Icons.add, color: Theme.of(context).primaryColor),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }
}
