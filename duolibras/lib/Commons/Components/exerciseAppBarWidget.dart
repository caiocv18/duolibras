import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:flutter/material.dart';

import 'progressBar.dart';

enum TabType { ContentBar, ExerciseBar }

class ExerciseAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final double _maxProgress;
  final Size _screenSize;
  late double _height;
  final int _numberOfLifes;
  late _ExerciseAppBarWidgetState _state;
  final TabType tabType;

  Function? showArrow;
  Function(int)? onUpdateLifes;
  Function(double)? onUpdateProgress;
  Function _onSkipPressed;
  Function _onNextExercisePressed;
  Function _onExitPressed;
  Function(TabType)? showContentTabBar;

  static late double appBarHeight;

  ExerciseAppBarWidget(
      this._maxProgress,
      this._screenSize,
      this._numberOfLifes,
      this.tabType,
      this._onNextExercisePressed,
      this._onExitPressed,
      this._onSkipPressed) {
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
  late bool _showContentTabBar;
  var _showNextExerciseArrow = false;
  double _currentProgress = 0;
  late var _currentLifes = widget._numberOfLifes;

  @override
  void initState() {
    super.initState();

    _showContentTabBar = widget.tabType == TabType.ContentBar;
  }

  @override
  Widget build(BuildContext context) {
    widget.showArrow = () {
      if (_showContentTabBar) return;
      setState(() {
        _showNextExerciseArrow = true;
      });
    };

    widget.onUpdateLifes = (lifes) {
      if (_showContentTabBar) return;
      setState(() {
        _currentLifes = lifes;
      });
    };

    widget.onUpdateProgress = (progress) {
      if (_showContentTabBar) return;
      setState(() {
        _currentProgress = progress;
      });
    };

    widget.showContentTabBar = (tabType) {
      setState(() {
        _showContentTabBar = tabType == TabType.ContentBar;
      });
    };

    return _showContentTabBar
        ? _buildContentTabBar(context)
        : _buildAppBar(context);
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
                if (!_showNextExerciseArrow)
                _buildLifeWidget(widget._numberOfLifes),
                if (_showNextExerciseArrow) _buildNextExerciseButton(size)
              ]),
              SizedBox(height: widget._height / 4),
              Center(
                child: Container(
                  height: widget._height / 5,
                  width: widget._screenSize.width * 0.8,
                  child: ProgressBar(
                      max: widget._maxProgress, current: _currentProgress),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildContentTabBar(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;

    return AppBar(
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
        foregroundColor: Colors.transparent,
        toolbarHeight: widget._height,
        leadingWidth: 0,
        elevation: 0,
        title: Container(
          width: double.infinity,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_buildSkipButton(size)]),
        ));
  }

  Widget _buildExitButton(Size containerSize) {
    return Container(
      width: containerSize.width * 0.21,
      child: OutlinedButton(
          onPressed: () => widget._onExitPressed(),
          child: Text("Desistir",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600)),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white))))),
    );
  }

  Widget _buildNextExerciseButton(Size containerSize) {
    return Container(
      width: containerSize.width * 0.21,
      child: OutlinedButton(
          onPressed: () {
            widget._onNextExercisePressed();
            _showNextExerciseArrow = false;
          },
          child:
              Image(image: AssetImage(Constants.imageAssets.nextExerciseArrow)),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white))))),
    );
  }

  Widget _buildLifeWidget(int numberOfLife) {
    List<Widget> lifes = [];
    for (var i = 0; i < _currentLifes; i++) {
      lifes.add(
        Image(
          image: AssetImage(Constants.imageAssets.lifeIcon),
          color: HexColor.fromHex("DF425E"),
        ),
      );
      lifes.add(SizedBox(width: 5));
    }
    final outlineHearts = 3 - _currentLifes;
    for (var i = 0; i < outlineHearts; i++) {
      lifes.add(
        Image(image: AssetImage(Constants.imageAssets.lifeIconEmpty)),
      );
      lifes.add(SizedBox(width: 5));
    }

    return Row(children: [...lifes]);
  }

  Widget _buildSkipButton(Size containerSize) {
    return Container(
      width: containerSize.width * 0.21,
      child: OutlinedButton(
          onPressed: () => widget._onSkipPressed(),
          child: Text("Pular",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600)),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white))))),
    );
  }
}
