import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_memo/common/constant/color.dart';
import 'package:flutter/cupertino.dart';

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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                color: const Color.fromARGB(255, 106, 42, 5),
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
                      color: PRIMARY_COLOR, // 라벤더 파스텔 색상 유지
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
                          color: BUTTON_TEXT_COLOR,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
