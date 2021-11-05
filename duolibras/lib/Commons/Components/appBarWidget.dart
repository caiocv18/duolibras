import 'package:duolibras/Commons/Components/gradientText.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  Function? longpressHandler;
  Function? backButtonPressed;
  String _title;

  late var appBar = AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    foregroundColor: HexColor.fromHex("4982F6"),
    title: Container(
      child: GradientText(
        _title,
        style: TextStyle(
            fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w700),
        gradient: LinearGradient(
            colors: [HexColor.fromHex("4982F6"), HexColor.fromHex("2CC4FC")],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
    ),
    automaticallyImplyLeading: true,
    // leading: _buildBackButton(),
    // leadingWidth: 82,
    actions: [
      GestureDetector(
          child: Container(width: 50, height: 30, color: Colors.transparent),
          onLongPress: () {
            if (longpressHandler != null) longpressHandler!();
          })
    ],
    bottom: AppBarBottom(),
    elevation: 1,
  );

  AppBarWidget(this._title,
      {required this.longpressHandler, required this.backButtonPressed});

  @override
  Widget build(BuildContext context) {
    return appBar;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => appBar.preferredSize;

  Widget? _buildBackButton() {
    if (backButtonPressed == null) return null;
    return GestureDetector(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Container(
                height: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(Constants.imageAssets.backArrow)))),
          ),
        ],
      ),
      onTap: () => backButtonPressed!(),
    );
  }
}

class AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 12,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [HexColor.fromHex("4982F6"), HexColor.fromHex("2CC4FC")]),
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 12);
}
