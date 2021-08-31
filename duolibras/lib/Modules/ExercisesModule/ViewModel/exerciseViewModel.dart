import 'package:duolibras/Commons/router.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ExercisesCategory.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';

import '../exerciseMultiChoiceScreen.dart';
import '../exerciseWritingScreen.dart';

class ExerciseViewModel with ExerciseWritingViewModel {
  List<Exercise> _exercises;
  final void Function(Exercise? exercise) _didFinishExercise;

  ExerciseViewModel(this._exercises, this._didFinishExercise);
  var exerciseProgressValue = 0.0;
  var totalPoints = 0.0;

  @override
  void didSubmitTextAnswer(
      String answer, String exerciseID, BuildContext context) {
    if (answer.isEmpty) {
      return;
    }
    final exercise = _exercises.where((exe) => exe.id == exerciseID).first;
    totalPoints += exercise.correctAnswer == answer ? exercise.score : 0.0;
    _handleMoveToNextExercise(exerciseID, context);
  }

  void _handleMoveToNextExercise(String exerciseID, BuildContext context) {
    final index = _exercises.indexWhere((m) => m.id == exerciseID);

    if (index + 1 == _exercises.length) {
      exerciseProgressValue = 1;
      _didFinishExercise(null);
    }

    final exercise = _exercises[index + 1];
    exerciseProgressValue = (index + 1) / _exercises.length;
    _didFinishExercise(exercise);
    //   final routeName = _exercises.first.category == ExercisesCategory.writing
    //       ? ExerciseWritingScreen.routeName
    //       : ExerciseMultiChoiceScreen.routeName;

    //   Navigator.of(context).pushNamed(routeName,
    //       arguments: {"exercise": exercise, "viewModel": this});

    //   Routes.pushNamed(routeName,
    //       navigator: Routes.mainNavigator,
    //       arguments: {"exercise": exercise, "viewModel": this});
  }
}
