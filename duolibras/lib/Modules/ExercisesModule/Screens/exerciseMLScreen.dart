import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/timeBar.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';
import 'exerciseScreen.dart';

class ExerciseMLScreen extends ExerciseStateful{
  static String routeName = "/ExerciseMLScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;
  final bool _isSpelling;

  ExerciseMLScreen(this._exercise, this._viewModel, this._isSpelling);

  @override
  _ExerciseMLScreenState createState() => _ExerciseMLScreenState();

}

class _ExerciseMLScreenState extends State<ExerciseMLScreen> {
  var _showingCamera = false;
  var _finishedExercise = false;
  var spelledText = "";
  var _isRightAnswer = false;
  final completer = Completer<void>();
  late double totalTime = widget._exercise.correctAnswer.split('').length * 15.0;
  // late ConfettiController controllerTopCenter;

  @override
  void initState() {
    super.initState();

    widget._viewModel.cameraHelper.completer.future.then((_) => {completer.complete()});

    widget._viewModel.cameraHelper.mlModel.tfLiteResultsController.stream.listen(
      (value) {
        //Update results on screen
        setState(() {
          _handleCameraPrediction(value.first.label, value.first.confidence, this.context);
        });
      },
      onDone: () {

      },
      onError: (error) {
      }
    );

    widget.handleNextExercise = () {
      _submitAnswer(this.context);
    };
    
    setState(() {
      // initController();
    });

  }

  // void initController() {
  //   controllerTopCenter =
  //       ConfettiController(duration: const Duration(seconds: 2));
  // }

    @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBarHeight = ExerciseAppBarWidget.appBarHeight;
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight = mediaQuery.size.height - (appBarHeight + paddingTop);
    final containerSize = Size(mediaQuery.size.width, containerHeight);

    return Scaffold(
          body: Container(
            height: containerHeight,
            color: Color.fromRGBO(234, 234, 234, 1),
            child:  
            SafeArea(child: _showingCamera ? _cameraBody(widget._exercise, containerSize, context) : 
            _buildOnboardingBody(widget._exercise, widget._viewModel, containerSize, context))
          )
        );
  }

  // Align buildConfettiWidget(controller, double blastDirection) {
  //   return Align(
  //     alignment: Alignment.topCenter,
  //     child: ConfettiWidget(
  //       maximumSize: Size(30, 30),
  //       shouldLoop: false,
  //       confettiController: controller,
  //       blastDirection: blastDirection,
  //       blastDirectionality: BlastDirectionality.directional,
  //       maxBlastForce: 20, // set a lower max blast force
  //       minBlastForce: 8, // set a lower min blast force
  //       emissionFrequency: 1, // a lot of particles at once
  //       gravity: 1,
  //     ),
  //   );
  // }

  Widget _buildOnboardingBody(Exercise exercise, ExerciseViewModel viewModel, Size containerSize, BuildContext ctx) {
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
                  widget._viewModel.cameraHelper.initializeCamera();
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
                      SizedBox(height: containerSize.height * 0.04),
                      _finishedExercise ? _buildFeedback(containerSize) : _buildCameraPreview(containerSize),
                      SizedBox(height: containerSize.height * 0.04),
                      _buildSpelledLetters()
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          // buildConfettiWidget(controllerTopCenter, 3.14 / 1),
          // buildConfettiWidget(controllerTopCenter, 3.14 / 4),
        ]),
      ],
    );
  }

  Widget _buildCameraPreview(Size containerSize) {
    final cameraRatio = widget._viewModel.cameraHelper.camera.value.aspectRatio;

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * cameraRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Container(
          width: containerSize.width * 0.93,
          height: containerSize.height * 0.65,
          decoration: BoxDecoration(
              color: Color.fromRGBO(200, 205, 219, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
          child: Center(
            child: Container(
              width: containerSize.width * 0.89,
              height: containerSize.height * 0.63,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                child: Transform.scale(scale: scale, child: CameraPreview(widget._viewModel.cameraHelper.camera))
              )
            )
          )
        ),
        TimeBar(Size(containerSize.width * 0.93, containerSize.height * 0.04), totalTime, [Color.fromRGBO(73, 130, 246, 1), Color.fromRGBO(44, 196, 252, 1)], 
        () => _finishExercise(false))
      ]
    );
  }

  Widget _buildQuestionText() {
    final question = widget._exercise.question;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: constraint.maxWidth * 0.89,
        height: 33,
        child:  Center(
          child: Text(
            question,
            style: TextStyle(fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w700),
          ),
        )
      );
    });
  }

  Widget _buildAnswerText() {
    final answer = widget._exercise.correctAnswer;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: constraint.maxWidth * 0.89,
        height: constraint.maxHeight * 0.075,
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(20))), 
        child: 
          Center(
            child: Text(
              answer,
              style: TextStyle(fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w500),
            ),
          )
      );
    });
  }

  Widget _buildSpelledLetters() {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Center(
        child: Container(
            width: constraint.maxWidth * 0.89,
            height: constraint.maxHeight * 0.075,
            decoration: 
            BoxDecoration(color: Colors.white, 
              border: Border.all(width: 5, color: _finishedExercise ? (_isRightAnswer ? Color.fromRGBO(147, 202, 250, 1) : Color.fromRGBO(233, 112, 112, 1)) : Colors.white) , 
              borderRadius: BorderRadius.all(Radius.circular(20))
            ), 
            child: 
              Center(
                child: Text(
                  spelledText,
                  style: TextStyle(fontSize: 24, fontFamily: "Nunito", fontWeight: FontWeight.w500, letterSpacing: 2.0),
                ),
              )
          )
      );
    });
  }

  void _handleCameraPrediction(String label, double confidence, BuildContext ctx) {
      if (!widget._isSpelling) {
        _handleCameraPredictionLetter(label, confidence, ctx);
      }
      else {
        _handleCameraPredictionSpelling(label, confidence, ctx);
      }
  }

  void _handleCameraPredictionLetter(String label, double confidence, BuildContext ctx){
    if (widget._viewModel.isGestureCorrect(label, confidence, widget._exercise) && !_finishedExercise) {
        // controllerTopCenter.play();
          setState(() {
            spelledText = label;
          });
          _finishExercise(true);
    }
  }

  void _handleCameraPredictionSpelling(String newLetter, double confidence, BuildContext ctx){
    if (widget._viewModel.isSpellingCorrect(newLetter, confidence, widget._exercise)) {
      setState(() {
        spelledText = widget._viewModel.spelledLetters.join();
      });
      if (spelledText == widget._exercise.correctAnswer) {
          // controllerTopCenter.play();
          _finishExercise(true);
      }
         
    }
  }

  Widget _buildFeedback(Size containerSize) {
    return Center(
      child: Container(
          width: containerSize.width * 0.89,
          height: containerSize.height * 0.5,
          decoration: 
          BoxDecoration(color: Colors.white, 
            border: Border.all(width: 5, color: _isRightAnswer ? Color.fromRGBO(147, 202, 250, 1) : Color.fromRGBO(233, 112, 112, 1)) , 
            borderRadius: BorderRadius.all(Radius.circular(20))
          ), 
        )
    );
  }

  void _finishExercise(bool rightAnswer) {
    setState(() {
      _finishedExercise = true;
      _isRightAnswer = rightAnswer;
      widget._viewModel.closeCamera();
      widget._viewModel.showNextArrow();
    });
  }

  void _submitAnswer(BuildContext ctx) {
    widget._viewModel.didSubmitTextAnswer(spelledText, widget._exercise.id, this.context);
  }

  @override
  void dispose() {
    super.dispose();
  }


}
