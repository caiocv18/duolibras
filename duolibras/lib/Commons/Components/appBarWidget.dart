import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  Function? _longpressHandler;
  String _title;

  late var appBar = AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Container(
            child: Column(
              children: [
                Text(_title, 
                style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, color: Colors.black)),
              ],
        )
      ),
      leading: null,
      actions: [GestureDetector(child: Container(width: 50, height: 30, color: Colors.transparent), onLongPress: () {
        if (_longpressHandler != null)
           _longpressHandler!();
      })],
      elevation: 1,
    );

  AppBarWidget(this._title, this._longpressHandler);

  @override
  Widget build(BuildContext context) {
    return appBar;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => appBar.preferredSize;
}
