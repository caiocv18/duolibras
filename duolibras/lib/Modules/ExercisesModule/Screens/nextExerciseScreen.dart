import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextExerciseScreen extends StatelessWidget {
  Function() handleNextExercise;
  Function() handleClose;
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.7; // from 0-1.0

  NextExerciseScreen(
      {required this.handleNextExercise, required this.handleClose, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Container(
      // color: Colors.red,
      width: screenSize.size.width,
      height: screenSize.size.height,
      child: Stack(alignment: Alignment.center, children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            color: Colors.grey.withOpacity(_opacity),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExerciseButton(
              child: Image(
                  width: 30,
                  height: 30,
                  image: AssetImage(
                      Constants.imageAssets.nextExerciseButtonArrow)),
              size: 200,
              color: HexColor.fromHex("6DB4FF"),
              isCircle: true,
              onPressed: () {
                Navigator.of(context).pop();
                handleNextExercise();
              },
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ExerciseButton(
              child: Image(
                  width: 15,
                  height: 15,
                  image: AssetImage(
                      Constants.imageAssets.nextExerciseCloseButton)),
              size: 100,
              color: HexColor.fromHex("6DB4FF"),
              isCircle: true,
              onPressed: () {
                Navigator.of(context).pop();
                handleClose();
              },
            ),
            SizedBox(height: 50)
          ],
        )
      ]),
    );
  }
}
