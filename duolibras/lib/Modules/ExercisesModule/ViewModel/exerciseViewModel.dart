import 'package:duolibras/MachineLearning/TFLite/tflite_helper.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/exerciseWritingScreen.dart';

class ExerciseViewModel with ExerciseWritingViewModel {
  List<Exercise> _exercises;
  String _moduleID;

  final void Function(Exercise? exercise) _didFinishExercise;
  final mlModel = TFLiteHelper();

  //ML Exercise spelling
  List<String> spelledLetters = [];

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

  bool isGestureCorrect(String label, double confidence, Exercise exercise) {
    return exercise.correctAnswer == label && confidence > 0.9;
  }

  bool isSpellingCorrect(String newLetter, double confidence, Exercise exercise) {
    final splittedAnswer = exercise.correctAnswer.split("");

    if (splittedAnswer[spelledLetters.length] == newLetter && confidence > 0.9) {
      spelledLetters.add(newLetter);
      return true;
    }
    return false;
  }

  void didSubmitGesture(String label, double confidence, Exercise exercise,
      BuildContext context) {
    if (exercise.correctAnswer == label && confidence > 0.8) {
      didSubmitTextAnswer(label, exercise.id, context);
    }
  }

  Future<void> _saveProgress(BuildContext context) async {
    final userProvider = Provider.of<UserModel>(context, listen: false);
    final index = userProvider.user.modulesProgress
        .indexWhere((prog) => prog.moduleId == _moduleID);
    ModuleProgress moduleProgress;
    if (index != -1) {
      final progress = userProvider.user.modulesProgress[index].progress + 1;
      final id = userProvider.user.modulesProgress[index].id;

      moduleProgress =
          ModuleProgress(id: id, moduleId: _moduleID, progress: progress);
      // user.modulesProgress[index] = moduleProgress;
      userProvider.setModulesProgress(moduleProgress);
    } else {
      moduleProgress = ModuleProgress(
          id: UniqueKey().toString(), moduleId: _moduleID, progress: 1);
      userProvider.setModulesProgress(moduleProgress);
    }
    await Service.instance.postModuleProgress(moduleProgress);
  }

  Future<void> _handleMoveToNextExercise(
      String exerciseID, BuildContext context) async {
    final index = _exercises.indexWhere((m) => m.id == exerciseID);

    if (index + 1 == _exercises.length) {
      await _saveProgress(context);
      exerciseProgressValue = 1;
      _didFinishExercise(null);
      return;
    }

    final exercise = _exercises[index + 1];
    exerciseProgressValue = index + 1;
    _didFinishExercise(exercise);
  }
}
