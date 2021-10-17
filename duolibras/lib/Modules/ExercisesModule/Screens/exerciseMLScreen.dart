import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/MachineLearning/Helpers/camera_helper.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'exerciseScreen.dart';
import 'package:confetti/confetti.dart';

class ExerciseMLScreen extends ExerciseStateful {
  static String routeName = "/ExerciseMLScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;
  final bool isSpelling;

  ExerciseMLScreen(this._exercise, this._viewModel, this.isSpelling);

  @override
  _ExerciseMLScreenState createState() => _ExerciseMLScreenState();
}

class _ExerciseMLScreenState extends State<ExerciseMLScreen> {
  var _showingCamera = false;
  var _finishedExercise = false;
  late CameraHelper cameraHelper =
      CameraHelper(widget._viewModel.mlModel, CameraLensDirection.front);
  final completer = Completer<void>();
  var spelledText = "";

  late ConfettiController controllerTopCenter;

  @override
  void initState() {
    super.initState();

    cameraHelper.completer.future.then((_) => {completer.complete()});

    widget._viewModel.mlModel.tfLiteResultsController.stream.listen((value) {
      //Update results on screen
      setState(() {
        _handleCameraPrediction(
            value.first.label, value.first.confidence, this.context);
      });
    }, onDone: () {}, onError: (error) {});

    widget.handleNextExercise = () {
      goNextExerciseFromAppBar();
    };

    setState(() {
      initController();
    });
  }

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBarHeight = ExerciseAppBarWidget.appBarHeight;
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight =
        mediaQuery.size.height - (appBarHeight + paddingTop);
    final containerSize = Size(mediaQuery.size.width, containerHeight);

    return Scaffold(
        body: Container(
            height: containerHeight,
            color: Color.fromRGBO(234, 234, 234, 1),
            child: SafeArea(
                child: _showingCamera
                    ? _cameraBody(widget._exercise, containerSize, context)
                    : _buildOnboardingBody(widget._exercise, widget._viewModel,
                        containerSize, context))));
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

  Widget _buildOnboardingBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: containerSize.height * 0.10,
            child: QuestionWidget("Faça o sinal em Libras")),
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
    );
  }

  Widget _cameraBody(Exercise exercise, Size containerSize, BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          Container(
            child: FutureBuilder<void>(
              future: completer.future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _buildQuestionText(),
                      _buildAnswerText(),
                      SizedBox(height: containerSize.height * 0.05),
                      Container(
                          width: containerSize.width * 0.95,
                          height: containerSize.height * 0.63,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(200, 205, 219, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          child: Center(
                              child: Container(
                                  width: containerSize.width * 0.91,
                                  height: containerSize.height * 0.605,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                      ),
                                      child: CameraPreview(
                                          cameraHelper.camera))))),
                      SizedBox(height: containerSize.height * 0.05),
                      _buildSpelledLetters()
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          buildConfettiWidget(controllerTopCenter, 3.14 / 1),
          buildConfettiWidget(controllerTopCenter, 3.14 / 4),
        ]),
      ],
    );
  }

  Widget _buildQuestionText() {
    final question = widget._exercise.question;
    return Text(
      question,
      style: TextStyle(
          fontSize: 24, color: Colors.black, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildAnswerText() {
    final answer = widget._exercise.correctAnswer;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Center(
          child: Container(
              width: constraint.maxWidth * 0.85,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Text(
                  answer,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              )));
    });
  }

  Widget _buildSpelledLetters() {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Center(
          child: Container(
              width: constraint.maxWidth * 0.85,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Text(
                  spelledText,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              )));
    });
  }

  void _handleCameraPrediction(
      String label, double confidence, BuildContext ctx) {
    if (!widget.isSpelling) {
      _handleCameraPredictionLetter(label, confidence, ctx);
    } else {
      _handleCameraPredictionSpelling(label, confidence, ctx);
    }
  }

  void _handleCameraPredictionLetter(
      String label, double confidence, BuildContext ctx) {
    if (widget._viewModel
            .isGestureCorrect(label, confidence, widget._exercise) &&
        !_finishedExercise) {
      _finishedExercise = true;
      controllerTopCenter.play();
      setState(() {
        spelledText = label;
        _closeAll(ctx);
      });
    }
  }

  void _handleCameraPredictionSpelling(
      String newLetter, double confidence, BuildContext ctx) {
    if (widget._viewModel
        .isSpellingCorrect(newLetter, confidence, widget._exercise)) {
      setState(() {
        spelledText = widget._viewModel.spelledLetters.join();
      });
      if (spelledText == widget._exercise.correctAnswer) {
        _finishedExercise = true;
        controllerTopCenter.play();
        setState(() {
          _closeAll(ctx);
        });
      }
    }
  }

  void _closeAll(BuildContext ctx) {
    widget._viewModel.showNextArrow();
    widget._viewModel.mlModel.close();
    Future.delayed(Duration(seconds: 2), () {
      cameraHelper.dispose();
      if (!mounted) {
        return;
      }
      setState(() {
        _showingCamera = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget._viewModel.mlModel.tfLiteResultsController.close();
    _showingCamera = false;
    cameraHelper.dispose();
  }

  void goNextExerciseFromAppBar() {
    _closeAll(this.context);
    widget._viewModel
        .didSubmitTextAnswer(spelledText, widget._exercise.id, this.context);
  }
}
