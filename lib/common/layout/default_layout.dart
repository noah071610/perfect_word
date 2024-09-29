import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? color;
  final String? title;
  final Widget child;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions; // 새로운 매개변수 추가
  final Widget? headerMenu; // 새로운 매개변수 추가

  const DefaultLayout({
    required this.child,
    this.title,
    this.color,
    this.bottomNavigationBar,
    this.actions, // 생성자에 actions 추가
    this.headerMenu, // 생성자에 headerMenu 추가
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color ?? Colors.white,
      body: child,
      appBar: renderAppbar(context),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppbar(BuildContext context) {
    if (title == null) return null;
    return AppBar(
      title: Text(
        title!,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      elevation: 0,
      actions: actions, // actions 추가
    );
  }
}
