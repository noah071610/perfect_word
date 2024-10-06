import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomToast(
    {required BuildContext context,
    required String message,
    bool isError = false}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: isError ? const Color(0xFFFFE6E6) : const Color(0xFFF5E6D3),
    ),
    child: Text(
      message,
      style: TextStyle(
          color: isError ? const Color(0xFFB71C1C) : const Color(0xFF8B4513),
          fontSize: 16.0),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: Duration(seconds: 2),
    positionedToastBuilder: (context, child) {
      final safeAreaTop = MediaQuery.of(context).padding.top;
      return Positioned(
        top: 16.0 + safeAreaTop,
        left: 16.0,
        right: 16.0,
        child: _ToastAnimation(child: child),
      );
    },
  );
}

FToast? _longPressToast;

void showLongPressToast(BuildContext context, bool isMaskingWord) {
  _longPressToast = FToast();
  _longPressToast!.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: const Color(0xFFF5E6D3),
    ),
    child: Text(
      isMaskingWord ? context.tr("view_word") : context.tr("view_meaning"),
      style: const TextStyle(color: Color(0xFF8B4513), fontSize: 16.0),
    ),
  );

  _longPressToast!.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(days: 365), // 매우 긴 시간 설정
    positionedToastBuilder: (context, child) {
      return Positioned(
        bottom: 50.0,
        left: 16.0,
        right: 16.0,
        child: _ToastAnimation(child: child, isBottom: true),
      );
    },
  );
}

void removeLongPressToast() {
  if (_longPressToast != null) {
    _longPressToast!.removeQueuedCustomToasts();
    _longPressToast = null;
  }
}

class _ToastAnimation extends StatelessWidget {
  final Widget child;
  final bool isBottom;

  const _ToastAnimation({Key? key, required this.child, this.isBottom = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0.0, (isBottom ? 50 : -50) * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
