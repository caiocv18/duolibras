import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:flutter/material.dart';

import 'progressBar.dart';

class ExerciseAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final double _maxProgress;
  final Size _screenSize;
  late double _height;
  final int _numberOfLifes;
  late _ExerciseAppBarWidgetState _state;

  Function? showArrow;
  Function(int)? onUpdateLifes;
  Function(double)? onUpdateProgress;
  Function _onNextExercisePressed;
  Function _onExitPressed;

  static late double appBarHeight;

  ExerciseAppBarWidget(
      this._maxProgress,
      this._screenSize,
      this._numberOfLifes, 
      this._onNextExercisePressed,
      this._onExitPressed) {
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
  double _currentProgress = 0;
  late var _currentLifes = widget._numberOfLifes;

  @override
  Widget build(BuildContext context) {
    widget.showArrow = () {
      setState(() {
        _showNextExerciseArrow = true;
      });
    };

    widget.onUpdateLifes = (lifes) {
      setState(() {
        _currentLifes = lifes;
      });
    };

    widget.onUpdateProgress = (progress) {
      setState(() {
        _currentProgress = progress;
      });
    };

    return _buildAppBar(context);
  }

  Widget _buildAppBar(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;

    return AppBar(
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
        foregroundColor: Colors.transparent,
        toolbarHeight: widget._height,
        leadingWidth: 0,
        elevation: 0,
        title: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildExitButton(size),
                _buildLifeWidget(widget._numberOfLifes),
                if (_showNextExerciseArrow)
                _buildNextExerciseButton(size)
              ]),
              SizedBox(height: widget._height / 4),
              Center(
                child: Container(
                  height: widget._height / 5,
                  width: widget._screenSize.width * 0.8,
                  child: ProgressBar(
                      max: widget._maxProgress,
                      current: _currentProgress),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildExitButton(Size containerSize) {
    return 
    Container(
      width: containerSize.width * 0.21,
      child: OutlinedButton(
          onPressed: () => widget._onExitPressed(),
          child: 
          Text("Desistir",
              style: 
              TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w500
              )
          ),
          style: 
          ButtonStyle(
              backgroundColor:MaterialStateProperty.all(Colors.white),
              shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white))
                  )
          )
      ),
    );
  }

  Widget _buildNextExerciseButton(Size containerSize) {
    return 
    Container(
        width: containerSize.width * 0.21,
        child: OutlinedButton(
            onPressed: () { 
              widget._onNextExercisePressed();
              _showNextExerciseArrow = false;
            },
            child: 
              Image(image: 
                AssetImage(
                    Constants.imageAssets.nextExerciseArrow)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white))
                        )
                    )
        ),
      );
  }

  Widget _buildLifeWidget(int numberOfLife) {
    List<Widget> lifes = [];
    for (var i = 0; i < _currentLifes; i++) {
      lifes.add(
        Image(image: AssetImage(Constants.imageAssets.lifeIcon)),
      );
      lifes.add(SizedBox(width: 5));
    }
    final outlineHearts = 3 - _currentLifes;
    for (var i = 0; i < outlineHearts; i++) {
      lifes.add(
        Image(image: AssetImage(Constants.imageAssets.lifeIconEmpty)),
      );
    }

    return Row(children: [...lifes]);
  }
}
