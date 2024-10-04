import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomToast(BuildContext context, String message) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: const Color(0xFFF5E6D3),
    ),
    child: Text(
      message,
      style: const TextStyle(color: Color(0xFF8B4513), fontSize: 16.0),
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

class _ToastAnimation extends StatelessWidget {
  final Widget child;

  const _ToastAnimation({Key? key, required this.child}) : super(key: key);

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
            offset: Offset(0.0, -50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
