import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/constant/data.dart';
import 'package:perfect_memo/common/layout/default_layout.dart';
import 'package:perfect_memo/common/widgets/list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:perfect_memo/common/provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSetting extends ConsumerStatefulWidget {
  const LanguageSetting({Key? key}) : super(key: key);

  @override
  _LanguageSettingState createState() => _LanguageSettingState();
}

class _LanguageSettingState extends ConsumerState<LanguageSetting> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: context.tr('language_settings'),
      centerTitle: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            children: [
              CustomListSection(
                  title: context.tr('select_language'),
                  items: supportLang.map((e) {
                    return CustomListItem(
                      title: e['label']!,
                      countryCode: e['value']!,
                      settingType: SettingType.checker,
                      isChecked: e['lang'] == context.locale.toString(),
                      onTap: () async {
                        await context.setLocale(Locale(e['lang']!));
                        setState(() {});
                      },
                    );
                  }).toList()),
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
