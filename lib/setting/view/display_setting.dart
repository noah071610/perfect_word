import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/layout/default_layout.dart';
import 'package:perfect_wordbook/common/provider/setting_provider.dart';
import 'package:perfect_wordbook/common/widgets/list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

class DisplaySettingTab extends ConsumerStatefulWidget {
  const DisplaySettingTab({Key? key}) : super(key: key);

  @override
  _DisplaySettingTabState createState() => _DisplaySettingTabState();
}

class _DisplaySettingTabState extends ConsumerState<DisplaySettingTab> {
  @override
  Widget build(BuildContext context) {
    final currentThemeMode = ref.watch(settingProvider).themeNum;

    return DefaultLayout(
      title: context.tr('display_settings'),
      centerTitle: true,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Column(
              children: [
                CustomListSection(
                  title: context.tr('screen'),
                  items: [
                    CustomListItem(
                      title: context.tr('system'),
                      icon: Icons.settings_system_daydream,
                      settingType: SettingType.checker,
                      isChecked: currentThemeMode == 0,
                      onTap: () => _updateThemeMode(0),
                    ),
                    CustomListItem(
                      title: context.tr('light'),
                      icon: Icons.light_mode,
                      settingType: SettingType.checker,
                      isChecked: currentThemeMode == 1,
                      onTap: () => _updateThemeMode(1),
                    ),
                    CustomListItem(
                      title: context.tr('dark'),
                      icon: Icons.dark_mode,
                      settingType: SettingType.checker,
                      isChecked: currentThemeMode == 2,
                      onTap: () => _updateThemeMode(2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateThemeMode(int themeNum) {
    ref.read(settingProvider.notifier).setThemeMode(themeNum);
  }
}
