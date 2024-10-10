import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:perfect_wordbook/common/model/setting_model.dart';
import 'package:perfect_wordbook/common/model/target_word_book_model.dart';
import 'package:perfect_wordbook/common/model/word_book_list_model.dart';
import 'package:perfect_wordbook/common/model/word_book_model.dart';
import 'package:perfect_wordbook/common/model/word_card_model.dart';
import 'package:perfect_wordbook/common/model/word_filter_model.dart';
import 'package:perfect_wordbook/common/provider/setting_provider.dart';
import 'package:perfect_wordbook/common/theme/custom_colors.dart';
import 'package:perfect_wordbook/setting/view/display_setting.dart';
import 'package:perfect_wordbook/setting/view/font_setting.dart';
import 'package:perfect_wordbook/setting/view/language_setting.dart';
import 'package:perfect_wordbook/common/view/root_tab.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/word/view/word_add_word_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:perfect_wordbook/word/view/word_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();

  // await Hive.deleteFromDisk();
  // try {
  //   final appDocumentDir =
  //       await path_provider.getApplicationDocumentsDirectory();
  //   final hivePath = appDocumentDir.path;

  //   // Hive 닫기
  //   await Hive.close();

  //   // Hive 디렉토리 삭제
  //   final directory = Directory(hivePath);
  //   if (await directory.exists()) {
  //     await directory.delete(recursive: true);
  //   }

  //   // Hive 재초기화
  //   Hive.init(hivePath);
  // } on HiveError catch (e) {
  //   await Hive.deleteFromDisk();
  // }

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(WordBookListModelAdapter());
  Hive.registerAdapter(WordBookModelAdapter());
  Hive.registerAdapter(WordCardModelAdapter());
  Hive.registerAdapter(WordFilterModelAdapter());
  Hive.registerAdapter(CardLayoutTypeAdapter());
  Hive.registerAdapter(CardSortTypeAdapter());
  Hive.registerAdapter(CardFormatAdapter()); // 6
  Hive.registerAdapter(CardMaskingTypeAdapter());
  Hive.registerAdapter(TargetWordBookModelAdapter());
  Hive.registerAdapter(SettingModelAdapter());

  EasyLocalization.logger.enableBuildModes = [];

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('ko'),
          Locale('ja'),
          Locale('th')
        ],

        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('ko'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingProvider);

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Perfect Wordbook',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: setting.themeNum == 0
          ? ThemeMode.system
          : setting.themeNum == 1
              ? ThemeMode.light
              : ThemeMode.dark,
      theme: ThemeData(
        textTheme: GoogleFonts.getTextTheme(setting.font).apply(
          bodyColor: BLACK_COLOR, // 기본 텍스트 색상 설정
          displayColor: BLACK_COLOR, // 제목 등의 텍스트 색상 설정
        ),
        scaffoldBackgroundColor: WHITE_COLOR,
        primaryColor: BUTTON_TEXT_COLOR, // 주 색상 설정
        cardColor: WHITE_COLOR, // 카드 배경색
        dividerColor: Colors.grey[300], // 구분선 색상
        iconTheme: IconThemeData(color: BODY_TEXT_COLOR), // 아이콘 색상
        colorScheme: ColorScheme.light(
          surface: PRIMARY_SOFT_COLOR, // ListTile 배경색
          primary: BUTTON_TEXT_COLOR, // 주 색상
          secondary: PRIMARY_COLOR, // 보조 색상
          outline: BODY_TEXT_COLOR,
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: ICON_COLOR),
          actionsIconTheme: IconThemeData(color: ICON_COLOR),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: WHITE_COLOR, // 팝업 메뉴 배경색
          textStyle: TextStyle(
            color: BLACK_COLOR, // 팝업 메뉴 텍스트 색상
            fontWeight: FontWeight.w400, // 텍스트 두께 조정
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: PRIMARY_COLOR, // 배경색
            foregroundColor: BUTTON_TEXT_COLOR, // 텍스트 색상
          ),
        ),
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
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return PRIMARY_COLOR.withOpacity(0.6);
              }
              return null;
            },
          ),
        ),
        splashFactory: InkRipple.splashFactory,
        splashColor: PRIMARY_COLOR.withOpacity(0.3),
        highlightColor: PRIMARY_COLOR.withOpacity(0.1),
        extensions: [
          CustomColors(
            containerBackground: Colors.grey.withOpacity(0.08),
            buttonBackground: PRIMARY_COLOR,
            buttonTextColor: BUTTON_TEXT_COLOR,
          ),
        ],
        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(color: BLACK_COLOR),
          subtitleTextStyle: TextStyle(color: BLACK_COLOR),
          leadingAndTrailingTextStyle: TextStyle(color: BLACK_COLOR),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey[200], // 다크 모드에서의 Divider 색상
          thickness: 1, // 선의 두께
        ),
        dialogTheme: DialogTheme(
          backgroundColor: WHITE_COLOR, // 라이트 테마에서 다이얼로그 배경색을 흰색으로 설정
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: WHITE_COLOR, // 라이트 모드에서의 바텀 시트 배경색
          modalBackgroundColor: WHITE_COLOR, // 모달 바텀 시트의 배경색
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: BLACK_COLOR),
          hintStyle: TextStyle(color: BODY_TEXT_COLOR),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: BLACK_COLOR),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: BLACK_COLOR,
        textTheme: GoogleFonts.getTextTheme(setting.font).apply(
          bodyColor: WHITE_COLOR, // 기본 텍스트 색상 설정
          displayColor: WHITE_COLOR, // 제목 등의 텍스트 색상 설정
        ),
        primaryColor: BORDER_COLOR, // 다크 모드 주 색상
        cardColor: Colors.grey[850], // 다크 모드 카드 배경색
        dividerColor: Colors.grey[700], // 다크 모드 구분선 색상
        iconTheme: IconThemeData(color: Colors.grey[300]), // 다크 모드 아이콘 색상
        colorScheme: ColorScheme.dark(
          surface: Colors.grey[900]!, // 다크 모드 ListTile 배경색
          primary: BORDER_COLOR, // 다크 모드 주 색상
          secondary: BORDER_COLOR, // 다크 모드 보조 색상
          outline: BODY_TEXT_COLOR,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.grey[850], // 다크 모드 팝업 메뉴 배경색
          textStyle: TextStyle(
            color: WHITE_COLOR, // 다크 모드 팝업 메뉴 텍스트 색상
            fontWeight: FontWeight.w400, // 텍스트 두께 조정
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: BORDER_COLOR, // 다크 모드 텍스트 버튼 색상
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: PRIMARY_DARK_COLOR, // 배경색
            foregroundColor: WHITE_COLOR, // 텍스트 색상
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[850],
        ),
        tabBarTheme: TabBarTheme(
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
        splashFactory: InkRipple.splashFactory,
        splashColor: WHITE_COLOR.withOpacity(0.1),
        highlightColor: WHITE_COLOR.withOpacity(0.1),
        extensions: [
          CustomColors(
            containerBackground: WHITE_COLOR.withOpacity(0.05),
            buttonBackground: PRIMARY_DARK_COLOR,
            buttonTextColor: WHITE_COLOR,
          ),
        ],
        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(color: WHITE_COLOR),
          subtitleTextStyle: TextStyle(color: WHITE_COLOR),
          leadingAndTrailingTextStyle: TextStyle(color: WHITE_COLOR),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey[700], // 다크 모드에서의 Divider 색상
          thickness: 1, // 선의 두께
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[850], // 다크 테마에서는 기존 상 유지
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey[850], // 다크 모드에서의 바텀 시트 배경색
          modalBackgroundColor: Colors.grey[850], // 다크 모드에서의 모달 바텀 시 배경색
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: WHITE_COLOR),
          hintStyle: TextStyle(color: Colors.grey[300]),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: WHITE_COLOR),
          actionsIconTheme: IconThemeData(color: WHITE_COLOR),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: WHITE_COLOR),
        ),
      ),
      builder: (context, child) {
        return Builder(
          builder: (BuildContext context) {
            final mediaQuery = MediaQuery.of(context);
            final constrainedWidth =
                mediaQuery.size.width > 600 ? 600.0 : mediaQuery.size.width;

            return Center(
              child: SizedBox(
                width: constrainedWidth,
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return RootTab();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'display-setting',
          builder: (BuildContext context, GoRouterState state) {
            return const DisplaySettingTab();
          },
        ),
        GoRoute(
          path: 'language-setting',
          builder: (BuildContext context, GoRouterState state) {
            return const LanguageSetting();
          },
        ),
        GoRoute(
          path: 'font-setting',
          builder: (BuildContext context, GoRouterState state) {
            return const FontSetting();
          },
        ),
        GoRoute(
          path: 'word_book',
          builder: (BuildContext context, GoRouterState state) {
            return WordScreen();
          },
          routes: [
            GoRoute(
              path: 'add',
              builder: (BuildContext context, GoRouterState state) {
                final Map<String, dynamic> extra =
                    state.extra as Map<String, dynamic>;
                return MemoAddWordScreen(
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
