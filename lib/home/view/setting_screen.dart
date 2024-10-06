import 'package:flutter/material.dart';
import 'package:perfect_memo/common/constant/toast.dart';
import 'package:perfect_memo/common/widgets/list_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            children: [
              CustomListSection(
                title: context.tr('settings'),
                items: [
                  CustomListItem(
                    title: context.tr('font_settings'),
                    icon: Icons.font_download,
                    settingType: SettingType.navigator,
                    onTap: () {
                      context.go('/font-setting');
                    },
                  ),
                  CustomListItem(
                    title: context.tr('language_settings'),
                    icon: Icons.language,
                    settingType: SettingType.navigator,
                    onTap: () {
                      context.go('/language-setting');
                    },
                  ),
                  CustomListItem(
                    title: context.tr('display_settings'),
                    icon: Icons.brightness_6,
                    settingType: SettingType.navigator,
                    onTap: () {
                      context.go('/display-setting');
                    },
                  ),
                ],
              ),
              CustomListSection(
                title: context.tr('etc'),
                items: [
                  CustomListItem(
                    title: context.tr('feedback_and_requests'),
                    icon: Icons.feedback,
                    onTap: () => _launchEmail(context),
                    settingType: SettingType.event,
                  ),
                  CustomListItem(
                    title: context.tr('version_info'),
                    icon: Icons.info,
                    settingType: SettingType.event,
                    onTap: () {
                      showCustomToast(context: context, message: 'v1.0.0');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchAppStore() async {
    final Uri url = Uri.parse(
      'https://apps.apple.com/app/id[YOUR_APP_ID]', // iOS 앱스토어 링크
      // 'https://play.google.com/store/apps/details?id=[YOUR_PACKAGE_NAME]', // 안드로이드 플레이스토어 링크
    );
    if (!await launchUrl(url)) {
      throw Exception('앱스토어를 열 수 없습니다');
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'noah071610@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': context.tr('feedback_and_requests'),
        'body': context.tr('feedback_help_message')
      }),
    );

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception(context.tr('cannot_open_email'));
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
