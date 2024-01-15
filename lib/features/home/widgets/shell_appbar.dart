import 'package:flutter/material.dart';

class ShellAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const ShellAppBar({super.key, required this.title});

  @override
  State<ShellAppBar> createState() => _ShellAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ShellAppBarState extends State<ShellAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
    );
  }
}
