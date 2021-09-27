import 'dart:async';

import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/cameraWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';
import 'exerciseScreen.dart';
import 'package:confetti/confetti.dart';

class ExerciseMLScreen extends ExerciseStateful {
  static String routeName = "/ExerciseMLScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseMLScreen(this._exercise, this._viewModel);

  @override
  _ExerciseMLScreenState createState() => _ExerciseMLScreenState();
}

class _ExerciseMLScreenState extends State<ExerciseMLScreen> {
  var _showingCamera = false;
  var _finishedExercise = false;

  late ConfettiController controllerTopCenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initController();
    });
  }

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: false,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.directional,
        maxBlastForce: 20, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force
        emissionFrequency: 1, // a lot of particles at once
        gravity: 1,
      ),
    );
  }

  Widget showQuestionBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        color: Color.fromRGBO(234, 234, 234, 1),
        height: containerSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: containerSize.height * 0.10,
                child: QuestionWidget(exercise.question)),
            SizedBox(height: 15),
            Container(
              height: containerSize.height * 0.08,
              width: containerSize.width * 0.7,
              child: ElevatedButton(
                child: Text("Abrir a Câmera"),
                onPressed: () {
                  setState(() {
                    _showingCamera = true;
                  });
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)))),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _handleCameraPrediction(
      String label, double confidence, BuildContext ctx) {
    if (widget._viewModel
            .isGestureCorrect(label, confidence, widget._exercise) &&
        !_finishedExercise) {
      _finishedExercise = true;
      controllerTopCenter.play();
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _showingCamera = false;
          widget.showFinishExerciseBottomSheet(
              true, widget._exercise.correctAnswer, ctx, () {
            widget._viewModel
                .didSubmitTextAnswer(label, widget._exercise.id, ctx);
          });
        });
      });
    }
  }

  Widget cameraBody(Exercise exercise, Size containerSize, BuildContext ctx) {
    return Container(
        child: Stack(children: [
      CameraWidget(
          exercise.correctAnswer,
          (label, confidence) =>
              _handleCameraPrediction(label, confidence, ctx)),
      buildConfettiWidget(controllerTopCenter, 3.14 / 1),
      buildConfettiWidget(controllerTopCenter, 3.14 / 4),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    final _containerHeight = _mediaQuery.size.height -
        (kBottomNavigationBarHeight +
            _mediaQuery.padding.bottom +
            50 +
            _mediaQuery.padding.top);
    final _containerWidth = _mediaQuery.size.width;

    final containerSize = Size(_containerWidth, _containerHeight);

    return Scaffold(
        body: _showingCamera
            ? cameraBody(widget._exercise, containerSize, context)
            : showQuestionBody(
                widget._exercise, widget._viewModel, containerSize, context));
  }
}
