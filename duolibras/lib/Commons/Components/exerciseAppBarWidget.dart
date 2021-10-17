import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:flutter/material.dart';

import 'progressBar.dart';

class ExerciseAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  Function _onNextExercisePressed;
  Function _onExitPressed;
  final double _maxProgress;
  final double _currentProgress;
  final Size _screenSize;
  late double _height;
  late _ExerciseAppBarWidgetState _state;
  Function? showArrow;
  static late double appBarHeight;
  int _numberOfLifes;

  ExerciseAppBarWidget(
      this._onNextExercisePressed,
      this._onExitPressed,
      this._maxProgress,
      this._currentProgress,
      this._screenSize,
      this._numberOfLifes) {
    ExerciseAppBarWidget.appBarHeight = _screenSize.height * 0.15;
    _height = _screenSize.height * 0.15;
  }

  @override
  State<ExerciseAppBarWidget> createState() {
    _state = _ExerciseAppBarWidgetState();
    return _state;
  }

  Size get preferredSize => Size(double.infinity, _screenSize.height * 0.15);
}

class _ExerciseAppBarWidgetState extends State<ExerciseAppBarWidget> {
  var _showNextExerciseArrow = false;

  @override
  Widget build(BuildContext context) {
    widget.showArrow = () {
      setState(() {
        _showNextExerciseArrow = true;
      });
    };

    return _buildAppBar(context);
  }

  Widget _buildAppBar(BuildContext ctx) {
    return AppBar(
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
        foregroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: widget._height,
        leadingWidth: 0.0,
        title: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: 82,
                  child: OutlinedButton(
                      onPressed: () => widget._onExitPressed(),
                      child: Text("Desistir",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white))))),
                ),
                _buildLifeWidget(widget._numberOfLifes),
                if (_showNextExerciseArrow)
                  Container(
                    width: 80,
                    child: OutlinedButton(
                        onPressed: () => widget._onNextExercisePressed(),
                        child: Image(
                            image: AssetImage(
                                Constants.imageAssets.nextExerciseArrow)),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white))))),
                  ),
              ]),
              SizedBox(height: widget._height / 4),
              Center(
                child: Container(
                  height: widget._height / 5,
                  width: widget._screenSize.width * 0.8,
                  child: ProgressBar(
                      max: widget._maxProgress,
                      current: widget._currentProgress),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildLifeWidget(int numberOfLife) {
    List<Widget> lifes = [];
    for (var i = 0; i < numberOfLife; i++) {
      lifes.add(
        Icon(
          Icons.favorite,
          color: Colors.red,
          size: 24.0,
        ),
      );
    }
    final outlineHearts = 3 - numberOfLife;
    for (var i = 0; i < outlineHearts; i++) {
      lifes.add(
        Icon(
          Icons.favorite_border_outlined,
          color: Colors.red,
          size: 24.0,
        ),
      );
    }

    return Row(children: [...lifes]);
  }
}
