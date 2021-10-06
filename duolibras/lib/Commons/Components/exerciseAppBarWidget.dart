import 'package:flutter/material.dart';

import 'progressBar.dart';

class ExerciseAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  
  Function _onExitPressed;
  final double _maxProgress;
  final double _currentProgress;
  final Size _screenSize;
  late double _height;

  Size get preferredSize => Size(double.infinity, _screenSize.height * 0.15);
  static late double appBarHeight;

  ExerciseAppBarWidget(this._onExitPressed, this._maxProgress, this._currentProgress, this._screenSize) {
    ExerciseAppBarWidget.appBarHeight = _screenSize.height * 0.15;
    _height = _screenSize.height * 0.15;
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context);
  }

  Widget _buildAppBar(BuildContext ctx) {
    return AppBar(
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
        foregroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: _height,
        leadingWidth: 0.0,
        title: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                  onPressed: () => _onExitPressed(),
                  child: Text("Desistir",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white))))),
              SizedBox(
                height: _height / 4
              ),
              Center(
                child: Container(
                  height: _height / 5,
                  width: _screenSize.width * 0.8,
                  child: ProgressBar(
                      max: _maxProgress,
                      current: _currentProgress),
                ),
              ),
            ],
          ),
        )
      );
  }


}
