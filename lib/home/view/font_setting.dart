import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:perfect_memo/common/model/word_card_model.dart';
import 'package:perfect_memo/common/provider/font_provider.dart';
import 'package:perfect_memo/common/widgets/font_size_slider.dart';
import 'package:perfect_memo/common/widgets/list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:perfect_memo/common/provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:perfect_memo/word/view/word_list_content.dart';

class FontSetting extends ConsumerStatefulWidget {
  const FontSetting({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FontSettingState();
}

class _FontSettingState extends ConsumerState<FontSetting> {
  @override
  Widget build(BuildContext context) {
    final curFont = ref.watch(fontProvider);

    return DefaultLayout(
      title: context.tr('font_settings'),
      centerTitle: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            children: [
              CustomListSection(
                title: context.tr('select_font'),
                items: [
                  'Noto Sans',
                  'Lato',
                  'Sunflower',
                  'Nanum Gothic',
                  'M PLUS 1p',
                  'Noto Sans Thai',
                ].map((e) {
                  return CustomListItem(
                      title: e,
                      font: e,
                      settingType: SettingType.checker,
                      isChecked: curFont == e,
                      onTap: () => ref.read(fontProvider.notifier).setFont(e));
                }).toList(),
              ),
              CustomListSectionCustom(
                title: context.tr('font_size'),
                child: Column(
                  children: [
                    FontSizeSlider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: CardMainContent(
                        onTap: () {},
                        card: WordCardModel(
                          key: 'example',
                          word: 'Word',
                          meaning: 'Meaning',
                          pronounce: "pronounce",
                          format: CardFormat.unchecked,
                          createdAt: DateTime.now(),
                        ),
                        index: 0,
                        hideMeaning: false,
                        hideWord: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateThemeMode(ThemeMode mode) {
    ref.read(themeProvider.notifier).setThemeMode(mode);
  }
}
