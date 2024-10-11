import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_wordbook/common/constant/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:perfect_wordbook/common/theme/custom_colors.dart';

class CustomDialog extends ConsumerWidget {
  final String title;
  final String btnText;
  final Widget child;
  final bool isYesOrNo;
  final void Function() onTap;

  const CustomDialog({
    super.key,
    required this.title,
    required this.btnText,
    required this.child,
    required this.onTap,
    this.isYesOrNo = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColors? theme = Theme.of(context).extension<CustomColors>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 30),
                    child,
                  ],
                ),
              ),
              SizedBox(height: 15),
              isYesOrNo
                  ? Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFE6D8D3), // 연한 파스텔 베이지
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 23.0),
                              child: Center(
                                child: Text(
                                  '취소',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 106, 42, 5),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: onTap,
                            child: Container(
                              decoration: BoxDecoration(
                                color: PRIMARY_COLOR,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 23.0),
                              child: Center(
                                child: Text(
                                  btnText,
                                  style: TextStyle(
                                    color: BUTTON_TEXT_COLOR,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: onTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme?.buttonBackground, // 라벤더 파스텔 색상 유지
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 23.0),
                        child: Center(
                          child: Text(
                            btnText,
                            style: TextStyle(
                              color: theme?.buttonTextColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Positioned(
            right: 10,
            top: -16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogTheme.backgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(Icons.close, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
