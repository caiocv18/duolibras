import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final appBar = AppBar(
    title: Text("Duolibras"),
    actions: [IconButton(icon: Icon(Icons.person), onPressed: () => {})],
    automaticallyImplyLeading: true,
  );
  @override
  Widget build(BuildContext context) {
    return appBar;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => appBar.preferredSize;
}
