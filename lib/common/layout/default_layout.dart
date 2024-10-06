import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  final String? title;
  final Color? color;
  final Widget child;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final void Function()? onClickTitle;
  final bool centerTitle;

  const DefaultLayout({
    required this.child,
    this.title,
    this.color,
    this.bottomNavigationBar,
    this.actions,
    this.onClickTitle = null,
    this.centerTitle = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      backgroundColor: color ?? null,
      body: SafeArea(
        top: true,
        bottom: true,
        child: child,
      ),
      appBar: renderAppbar(context),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppbar(BuildContext context) {
    if (title == null) return null;

    return AppBar(
      title: GestureDetector(
        onTap: onClickTitle,
        child: Text(
          title!,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
      elevation: 0,
      actions: actions,
      centerTitle: centerTitle,
    );
  }
}
