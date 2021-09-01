import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:flutter/material.dart';

import '../exerciseWritingScreen.dart';

class ExerciseViewModel with ExerciseWritingViewModel {
  List<Exercise> _exercises;
  String _moduleID;

  final void Function(Exercise? exercise) _didFinishExercise;

  ExerciseViewModel(this._exercises, this._moduleID, this._didFinishExercise);
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

  bool isAnswerCorrect(String answer, String exerciseID) {
    if (answer.isEmpty) {
      return false;
    }
    final exercise = _exercises.where((exe) => exe.id == exerciseID).first;
    return exercise.correctAnswer == answer;
  }

  Future<void> _saveProgress() async {
    if (UserSession.instance.user == null) {
      return;
    }

    List<ModuleProgress> modulesProgress =
        UserSession.instance.user!.modulesProgress ?? [];

    modulesProgress.add(ModuleProgress(
        id: "moduleProgress${_moduleID}", moduleId: _moduleID, progress: 1));
    UserSession.instance.user!.modulesProgress = modulesProgress;
    // await Service.instance.postModulesProgress(modulesProgress);
  }

  Future<void> _handleMoveToNextExercise(
      String exerciseID, BuildContext context) async {
    final index = _exercises.indexWhere((m) => m.id == exerciseID);

    if (index + 1 == _exercises.length) {
      await _saveProgress();
      exerciseProgressValue = 1;
      _didFinishExercise(null);
      return;
    }

    final exercise = _exercises[index + 1];
    exerciseProgressValue = (index + 1) / _exercises.length;
    _didFinishExercise(exercise);
  }
}
