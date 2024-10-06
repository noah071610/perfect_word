import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:perfect_memo/common/theme/custom_colors.dart';
import 'package:perfect_memo/common/widgets/country_image.dart';

enum SettingType {
  toggle,
  navigator,
  checker,
  event,
}

class CustomListSection extends StatelessWidget {
  final String title;
  final List<CustomListItem> items;

  const CustomListSection({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 2),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context)
                .extension<CustomColors>()
                ?.containerBackground,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 30,
              endIndent: 30,
            ),
            itemBuilder: (context, index) => items[index],
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class CustomListSectionCustom extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomListSectionCustom({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 2),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context)
                .extension<CustomColors>()
                ?.containerBackground,
          ),
          child: child,
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class CustomListItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final String? countryCode;
  final String? font;
  final SettingType settingType;
  final bool? isToggled;
  final bool? isChecked;

  const CustomListItem({
    Key? key,
    required this.title,
    this.icon,
    this.countryCode,
    this.font,
    required this.onTap,
    required this.settingType,
    this.isToggled,
    this.isChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? defaultTextStyle = Theme.of(context).textTheme.bodyMedium;

    return ListTile(
      leading:
          countryCode != null ? CountryImage(language: countryCode!) : null,
      title: Text(
        title,
        style: font != null ? GoogleFonts.getFont(font!) : defaultTextStyle,
      ),
      trailing: _buildTrailing(),
      onTap: settingType == SettingType.checker && isChecked == true
          ? null
          : onTap,
    );
  }

  Widget? _buildTrailing() {
    switch (settingType) {
      case SettingType.toggle:
        return Switch(
          value: isToggled ?? false,
          onChanged: (value) => onTap(),
        );
      case SettingType.navigator:
        return Icon(Icons.chevron_right, color: BODY_TEXT_COLOR);
      case SettingType.checker:
        return isChecked == true
            ? Icon(Icons.check, color: BUTTON_TEXT_COLOR)
            : null;
      case SettingType.event:
        return null;
    }
  }
}
