import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliverLayout extends ConsumerWidget {
  final String? title;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final List<Widget> slivers;
  final PreferredSizeWidget? bottom;
  final void Function()? onClickTitle;

  const SliverLayout({
    required this.slivers,
    this.title,
    this.bottomNavigationBar,
    this.actions,
    this.bottom,
    this.onClickTitle = null,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [renderSliverAppbar(context, ref), ...slivers],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  SliverAppBar renderSliverAppbar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      title: GestureDetector(
        onTap: onClickTitle,
        child: Text(
          title!,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
      elevation: 0,
      pinned: false,
      floating: true,
      snap: true,
      actions: [
        if (actions != null) ...actions!,
      ],
      bottom: bottom,
      centerTitle: false,
    );
  }
}
