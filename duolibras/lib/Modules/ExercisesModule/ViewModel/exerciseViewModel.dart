import 'package:camera/camera.dart';
import 'package:duolibras/Commons/ViewModel/ScreenState.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/MachineLearning/Helpers/camera_helper.dart';
import 'package:duolibras/MachineLearning/TFLite/tflite_helper.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/feedbackExerciseScreen.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../Screens/exerciseWritingScreen.dart';
import '../exerciseFlow.dart';

class ExerciseViewModel extends BaseViewModel with ExerciseWritingViewModel {
  final Tuple2<List<Exercise>, Module> exercisesAndModule;

  // final void Function(Exercise? exercise) _didFinishExercise;
  final ExerciseFlowDelegate exerciseFlowDelegate;
  late List<Exercise> exercises;

  //ML Exercise 
  final CameraHelper cameraHelper = CameraHelper(TFLiteHelper(), CameraLensDirection.front);
  List<String> spelledLetters = [];
 

  ExerciseViewModel(this.exercisesAndModule, this.exerciseFlowDelegate) {
    exercises = exercisesAndModule.item1;
  }

  var exerciseProgressValue = 0.0;
  var totalPoints = 0.0;
  var wrongAnswers = 0;

  var lifes = 3;

  @override
  void didSubmitTextAnswer(
      String answer, String exerciseID, BuildContext context) {
    if (answer.isEmpty) {
      return;
    }
    final exercise = exercises.where((exe) => exe.id == exerciseID).first;

    final isAnswerCorrect = exercise.correctAnswer == answer;

    totalPoints += isAnswerCorrect ? exercise.score : 0.0;

    _handleMoveToNextExercise(exerciseID, context);
  }

  bool _handleFinishModule(bool isAnswerCorrect) {
    wrongAnswers += isAnswerCorrect ? 0 : 1;

    lifes -= wrongAnswers;
    exerciseFlowDelegate.updateNumberOfLifes(lifes);

    if (lifes == 0) {
      exerciseFlowDelegate.didFinishExercise(null, FeedbackStatus.Failed);
      return true;
    }
    return false;
  }

  bool isAnswerCorrect(String answer, String exerciseID) {
    if (answer.isEmpty) {
      _handleFinishModule(false);
      return false;
    }
    final exercise = exercises.where((exe) => exe.id == exerciseID).first;
    _handleFinishModule(exercise.correctAnswer == answer);
    return exercise.correctAnswer == answer;
  }

  bool isGestureCorrect(String label, double confidence, Exercise exercise) {
    return exercise.correctAnswer == label && confidence > 0.9;
  }

  bool isSpellingCorrect(
      String newLetter, double confidence, Exercise exercise) {
    final splittedAnswer = exercise.correctAnswer.split("");

    if (splittedAnswer[spelledLetters.length] == newLetter &&
        confidence > 0.9) {
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
        .indexWhere((prog) => prog.moduleId == exercisesAndModule.item2.id);

    ModuleProgress moduleProgress;

    if (index != -1) {
      if (userProvider.user.modulesProgress[index].progress >=
          exercisesAndModule.item2.maxProgress) return;

      final progress = userProvider.user.modulesProgress[index].progress + 1;
      final id = userProvider.user.modulesProgress[index].id;

      moduleProgress = ModuleProgress(
          id: id, moduleId: exercisesAndModule.item2.id, progress: progress);
      userProvider.setModulesProgress(moduleProgress);
    } else {
      moduleProgress = ModuleProgress(
          id: UniqueKey().toString(),
          moduleId: exercisesAndModule.item2.id,
          progress: 1);
      userProvider.setModulesProgress(moduleProgress);
    }
    await Service.instance.postModuleProgress(moduleProgress);
  }

  Future<void> _handleMoveToNextExercise(
      String exerciseID, BuildContext context) async {
    final index = exercises.indexWhere((m) => m.id == exerciseID);

    if (index + 1 == exercises.length) {
      await _saveProgress(context);
      exerciseProgressValue = index + 1;
      exerciseFlowDelegate.didFinishExercise(null, FeedbackStatus.Success);
      return;
    }

    final exercise = exercises[index + 1];
    exerciseProgressValue = index + 1;
    exerciseFlowDelegate.didFinishExercise(exercise, null);
  }

  void showNextArrow() {
    exerciseFlowDelegate.didSelectAnswer();
  }
}

extension FeedbackScreenViewModel on ExerciseViewModel {
  void goToNextLevel(BuildContext context) async {
    setState(ScreenState.Loading);

    final level = _getUserModuleLevel(context, exercisesAndModule.item2.id);

    await Service.instance
        .getExercisesFromModuleId(exerciseFlowDelegate.sectionID,
            exercisesAndModule.item2.id, level + 1)
        .then((exercises) {
      exerciseFlowDelegate.startNewExercisesLevel(exercises);
    });
  }

  void tryModuleAgain() {
    exerciseFlowDelegate.restartLevel();
  }

  Future<bool> hasMoreExercises(BuildContext context) async {
    setState(ScreenState.Loading);

    final userProgress =
        _getUserModuleLevel(context, exercisesAndModule.item2.id);

    if (userProgress >= exercisesAndModule.item2.maxProgress) {
      setState(ScreenState.Normal);
      return false;
    }

    return Future.delayed(Duration(seconds: 2), () {}).then((_) {
      setState(ScreenState.Normal);
      return true;
    }).onError((error, stackTrace) => true);
  }

  void finishModuleFlow() {
    exerciseFlowDelegate.handleFinishFLow(true);
  }

  int _getUserModuleLevel(BuildContext ctx, String moduleID) {
    final user = Provider.of<UserModel>(ctx, listen: false).user;

    try {
      final module = user.modulesProgress
          .firstWhere((element) => element.moduleId == moduleID);
      return module.progress;
    } on StateError catch (_) {
      return 1;
    }
  }

  void closeCamera() async {
    await cameraHelper.close();
    await cameraHelper.mlModel.close();
  }
}
