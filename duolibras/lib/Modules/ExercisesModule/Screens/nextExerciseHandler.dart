import 'package:duolibras/Modules/ExercisesModule/Screens/nextExerciseScreen.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NextExerciseHandler {
  NextExerciseHandler();
  static NextExerciseScreen? _screen;

  static void showNextExerciseScreen(BuildContext context,
      {bool enableDrag = false,
      required Function() handleNextExercise,
      required Function() exitClosure}) {
    _screen = NextExerciseScreen(
        handleNextExercise: handleNextExercise, handleClose: exitClosure);

    showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation, widget) => WillPopScope(
          onWillPop: () async {
            exitClosure();
            return true;
          },
          child: _screen!),
    );
  }
}
