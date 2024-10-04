import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/model/word_book_list_model.dart';
import 'package:perfect_memo/common/model/word_book_model.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';
import 'package:perfect_memo/common/model/word_filter_model.dart';
import 'package:perfect_memo/home/view/root_tab.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/word/view/word_add_word_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:perfect_memo/word/view/word_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  bool hive_dev = false;
  if (hive_dev) {
    await Hive.deleteFromDisk();
    try {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      final hivePath = appDocumentDir.path;

      // Hive 닫기
      await Hive.close();

      // Hive 디렉토리 삭제
      final directory = Directory(hivePath);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }

      // Hive 재초기화
      Hive.init(hivePath);
    } on HiveError catch (e) {
      await Hive.deleteFromDisk();
    }
  } else {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }

  Hive.registerAdapter(WordBookListModelAdapter());
  Hive.registerAdapter(WordBookModelAdapter());
  Hive.registerAdapter(WordCardModelAdapter());
  Hive.registerAdapter(WordFilterModelAdapter());
  Hive.registerAdapter(CardLayoutTypeAdapter());
  Hive.registerAdapter(CardSortTypeAdapter());
  Hive.registerAdapter(CardFormatAdapter()); // 6
  Hive.registerAdapter(CardMaskingTypeAdapter());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Perfect Memo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'NotoSansKR',
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white, // 다이얼로그 배경색
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: PRIMARY_SOFT_COLOR,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: PRIMARY_SOFT_COLOR,
          selectedItemColor: BUTTON_TEXT_COLOR,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
        // 추가된 부분
        tabBarTheme: TabBarTheme(
          labelColor: BUTTON_TEXT_COLOR,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            color: PRIMARY_COLOR,
            border: Border(
              bottom: BorderSide(
                color: BUTTON_TEXT_COLOR,
                width: 2.0,
              ),
            ),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        splashColor: PRIMARY_COLOR.withOpacity(0.3),
        highlightColor: PRIMARY_COLOR.withOpacity(0.1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const RootTab();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'word_book',
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            return WordScreen(
              wordBookKey: extra['wordBookKey']! as String,
              wordBookListKey: extra['wordBookListKey']! as String,
              wordBookTitle: extra['wordBookTitle']! as String,
            );
          },
          routes: [
            GoRoute(
              path: 'add',
              builder: (BuildContext context, GoRouterState state) {
                final Map<String, dynamic> extra =
                    state.extra as Map<String, dynamic>;
                return MemoAddWordScreen(
                  wordBookKey: extra['wordBookKey']! as String,
                  wordBookListKey: extra['wordBookListKey']! as String,
                  wordBookTitle: extra['wordBookTitle']! as String,
                  targetIndex: extra['targetIndex'] as int,
                  wordKey: extra['wordKey'] as String?,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
