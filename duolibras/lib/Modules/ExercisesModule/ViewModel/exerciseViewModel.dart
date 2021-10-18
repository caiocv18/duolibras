import 'dart:async';

import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/MachineLearning/Helpers/camera_helper.dart';
import 'package:duolibras/MachineLearning/Helpers/result.dart';
import 'package:duolibras/MachineLearning/TFLite/tflite_helper.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/feedbackExerciseScreen.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/service.dart';
import 'package:duolibras/Services/Models/sectionProgress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../exerciseFlow.dart';

class ExerciseViewModel extends BaseViewModel {
  final Tuple2<List<Exercise>, Module> exercisesAndModule;
  final ExerciseFlowDelegate exerciseFlowDelegate;
  late List<Exercise> exercises;
  final _errorHandler = ErrorHandler();

  //ML Exercise
  final CameraHelper _cameraHelper =
      CameraHelper(TFLiteHelper(), CameraLensDirection.front);
  List<String> spelledLetters = [];

  ExerciseViewModel(this.exercisesAndModule, this.exerciseFlowDelegate) {
    exercises = exercisesAndModule.item1;
  }

  var exerciseProgressValue = 0.0;
  var totalPoints = 0.0;

  var lifes = 3;

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

  void didSubmitTextAnswer(
      String answer, String exerciseID, BuildContext context) {
    final exercise = exercises.where((exe) => exe.id == exerciseID).first;
    final isAnswerCorrect = exercise.correctAnswer == answer;
    totalPoints += isAnswerCorrect ? (exercise.score ?? 0) : 0.0;

    _handleMoveToNextExercise(exerciseID, context);
  }

  Future<void> _saveProgress(BuildContext context,
      {Function? exitClosure = null}) async {
    final userProvider = Provider.of<UserModel>(context, listen: false);

    var moduleProgressIndex = -1;
    var sectionsProgressIndex = -1;

    try {
      sectionsProgressIndex = userProvider.user.sectionsProgress
          .indexWhere((s) => s.sectionId == exerciseFlowDelegate.sectionID);
    } on StateError catch (_) {
      sectionsProgressIndex = -1;
    }
    late SectionProgress? sectionProgress;

    if (sectionsProgressIndex != -1) {
      sectionProgress = userProvider.incrementModulesProgress(
          exerciseFlowDelegate.sectionID,
          exercisesAndModule.item2.id,
          exercisesAndModule.item2.maxProgress);
    } else {
      sectionProgress = SectionProgress(
          id: UniqueKey().toString(),
          sectionId: exerciseFlowDelegate.sectionID,
          progress: 1,
          modulesProgress: []);
      sectionProgress.modulesProgress.add(ModuleProgress(
          id: UniqueKey().toString(),
          moduleId: exercisesAndModule.item2.id,
          progress: 1,
          maxModuleProgress: exercisesAndModule.item2.maxProgress));
      userProvider.addSectionProgress(sectionProgress);
    }

    if (sectionProgress == null) {
      return;
    }

    await Service.instance
        .postSectionProgress(sectionProgress)
        .onError((error, stackTrace) {
      final AppError appError = Utils.tryCast(error,
          fallback: AppError(AppErrorType.Unknown, "Erro desconhecido"));
      debugPrint("Error Exercise View Model: $appError.description");

      Completer<bool> completer = Completer<bool>();
      _errorHandler.showModal(appError, context, tryAgainClosure: () {
        return Service.instance
            .postSectionProgress(sectionProgress!)
            .then((value) => completer.complete(value))
            .onError((error, stackTrace) {
          _errorHandler.showModal(appError, context, exitClosure: () {
            if (exitClosure != null) exitClosure();
            completer.complete(false);
          });
        });
      }, exitClosure: exitClosure);
      return completer.future;
    });
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

  bool _handleFinishModule(bool isAnswerCorrect) {
    if (isAnswerCorrect) return false;

    lifes -= 1;
    exerciseFlowDelegate.updateNumberOfLifes(lifes);

    if (lifes == 0) {
      exerciseFlowDelegate.didFinishExercise(null, FeedbackStatus.Failed);
      return true;
    }
    return false;
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
      final module = user.sectionsProgress
          .firstWhere((s) => s.sectionId == exerciseFlowDelegate.sectionID)
          .modulesProgress
          .firstWhere((element) => element.moduleId == moduleID);
      return module.progress;
    } on StateError catch (_) {
      return 1;
    }
  }

  CameraController getCamera() {
    return _cameraHelper.camera;
  }

  Stream<List<Result>> getMlModelStream() {
    return _cameraHelper.mlModel.tfLiteResultsController.stream;
  }

  Future<void> initializeCamera() {
    return _cameraHelper.initializeCamera();
  }

  void closeCamera() async {
    await _cameraHelper.close();
    await _cameraHelper.mlModel.close();
  }
}
