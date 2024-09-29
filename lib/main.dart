import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perfect_memo/common/constant/data.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_memo/home/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/create/view/create_screen.dart';
import 'package:perfect_memo/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool hive_dev = true;
  if (hive_dev) {
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
  } else {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Perfect Memo',
      theme:
          MaterialTheme(Typography.material2021().black).light(), // 라이트 테마 적용
      darkTheme:
          MaterialTheme(Typography.material2021().white).dark(), // 다크 테마 적용
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
          path: 'create',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final random = Random().nextInt(emojis.length);
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: CreateTab(
                memoKey: state.uri.queryParameters['memoKey'] as String,
                emoji: emojis[random],
                color: pastelColors[random],
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          },
        ),
      ],
    ),
  ],
);
