import 'package:flutter/material.dart';

abstract class ExerciseScreenDelegate {
  Function? handleNextExercise;
  void goNextExercise() {
    if (handleNextExercise != null) handleNextExercise!();
  }
}

abstract class ExerciseStateless extends StatelessWidget with ExerciseScreenDelegate {
}

abstract class ExerciseStateful extends StatefulWidget with ExerciseScreenDelegate {
}
