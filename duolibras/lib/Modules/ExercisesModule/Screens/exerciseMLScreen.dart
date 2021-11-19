import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/timeBar.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:flutter/material.dart';
import 'exerciseScreen.dart';

class ExerciseMLScreen extends ExerciseStateful {
  static String routeName = "/ExerciseMLScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;
  final bool _isSpelling;
  final timerHandler = TimerHandler(Duration(seconds: 1));
  final maxCorrectAnswers = 10;
  var _progress = 0.0;
  late double progressStep = 1.0 / maxCorrectAnswers;

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
  late double totalTime =
      widget._exercise.correctAnswer.split('').length * 15.0;
  final boundingBoxKey = GlobalKey();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    widget.handleNextExercise = () {
      _submitAnswer(this.context);
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.imageAssets.background_home),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SafeArea(
          bottom: false,
          child: LayoutBuilder(builder: (ctx, constraint) {
            return SingleChildScrollView(
                child: Stack(children: [
              _showingCamera
                  ? _cameraBody(widget._exercise,
                      Size(constraint.maxWidth, constraint.maxHeight), context)
                  : _buildOnboardingBody(widget._exercise, widget._viewModel,
                      Size(constraint.maxWidth, constraint.maxHeight), context)
            ]));
          }))
    ]));
  }

  Widget _buildOnboardingBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return Container(
      height: containerSize.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: QuestionWidget("Faça o sinal em Libras")),
            SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: widget._viewModel.getHandDirection(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Container(
                        width: containerSize.width * 0.7,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 200,
                              child: ExerciseButton(
                                child: Center(
                                  child: Text("Abrir a Câmera",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontFamily: "Nunito",
                                          fontWeight: FontWeight.w500)),
                                ),
                                size: 30,
                                color: HexColor.fromHex("#93CAFA"),
                                onPressed: () => _startCamera(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : chooseHandWidget();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget chooseHandWidget() {
    return Column(children: [
      Text("Qual a mão que você irá fazer o sinal?",
          style: TextStyle(
              fontSize: 20, fontFamily: "Nunito", fontWeight: FontWeight.w500)),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 120,
            child: ExerciseButton(
              child: Center(
                child: Text("Esquerda"),
              ),
              size: 20,
              color: HexColor.fromHex("#93CAFA"),
              onPressed: () => {
                widget._viewModel
                    .setHandDirection(HandDirection.LEFT)
                    .then((value) => _startCamera())
              },
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            height: 40,
            width: 120,
            child: ExerciseButton(
              child: Center(
                child: Text("Direita"),
              ),
              size: 20,
              color: HexColor.fromHex("#93CAFA"),
              onPressed: () => {
                widget._viewModel
                    .setHandDirection(HandDirection.RIGHT)
                    .then((value) => _startCamera())
              },
            ),
          ),
        ],
      ),
    ]);
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
                      SizedBox(height: containerSize.height * 0.03),
                      // _finishedExercise
                      //     ? _buildFeedback(containerSize)
                      //     :
                      _buildCameraPreview(containerSize),
                      SizedBox(height: containerSize.height * 0.03),
                      _buildSpelledLetters()
                    ],
                  );
                } else {
                  return Container(
                      height: containerSize.height,
                      width: double.infinity,
                      child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildCameraPreview(Size containerSize) {
    final cameraRatio = widget._viewModel.getCamera().value.aspectRatio;

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * cameraRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      width: containerSize.width * 0.95,
      height: containerSize.height * 0.7,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: containerSize.width * 0.95,
                height: containerSize.height * 0.67,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(200, 205, 219, 1),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              ),
              Center(
                  child: Container(
                      width: containerSize.width * 0.90,
                      height: containerSize.height * 0.64,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Transform.scale(
                              scale: scale,
                              child: CameraPreview(
                                  widget._viewModel.getCamera()))))),
              FutureBuilder(
                future: widget._viewModel.getHandDirection(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    HandDirection direction = Utils.tryCast(snapshot.data!,
                        fallback: HandDirection.RIGHT);
                    if (!_finishedExercise) return direction.positionBox;
                  }
                  return Container();
                },
              )
            ],
          ),
          SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TimeBar(
                  Size(containerSize.width * 0.93, containerSize.height * 0.02),
                  totalTime,
                  [
                    Color.fromRGBO(73, 130, 246, 1),
                    Color.fromRGBO(44, 196, 252, 1)
                  ],
                  widget.timerHandler, () {
                widget._viewModel.isAnswerCorrect("", widget._exercise.id);
                _finishExercise(false);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionText() {
    final question = widget._exercise.question;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
          width: constraint.maxWidth * 0.89,
          height: 33,
          child: Center(
            child: AutoSizeText(
              question ?? "",
              maxFontSize: 22,
              minFontSize: 19,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700),
            ),
          ));
    });
  }

  Widget _buildAnswerText() {
    final answer = widget._exercise.correctAnswer;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
          width: constraint.maxWidth * 0.89,
          height: 54,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(
              answer,
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w500),
            ),
          ));
    });
  }

  Widget _buildSpelledLetters() {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Stack(children: [
        Center(
            child: TweenAnimationBuilder(
          tween: Tween(
              begin: 0.0, end: _finishedExercise ? 1.0 : widget._progress),
          duration: Duration(milliseconds: _finishedExercise ? 0 : 500),
          builder: (BuildContext context, double value, Widget? child) {
            final color = _finishedExercise
                ? (_isRightAnswer
                    ? Color.fromRGBO(100, 193, 149, 0.9)
                    : Color.fromRGBO(233, 112, 112, 0.9))
                : Color.fromRGBO(100, 193, 149, 0.9);

            return Container(
                child: Stack(alignment: Alignment.center, children: [
              ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                            startAngle: 3 * math.pi / 2,
                            endAngle: 7 * math.pi / 2,
                            tileMode: TileMode.repeated,
                            stops: [value, value],
                            colors: [color, Colors.transparent],
                            center: Alignment.center)
                        .createShader(rect);
                  },
                  child: Center(
                    child: Container(
                      width: constraint.maxWidth * 0.89,
                      height: constraint.maxWidth * 0.13,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                    ),
                  )),
              Center(
                  child: Container(
                      width: constraint.maxWidth * 0.86,
                      height: constraint.maxWidth * 0.10,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          spelledText,
                          style: TextStyle(
                              color: _finishedExercise
                                  ? (_isRightAnswer
                                      ? Color.fromRGBO(100, 193, 149, 1.0)
                                      : Color.fromRGBO(233, 112, 112, 1.0))
                                  : Color.fromRGBO(100, 193, 149, 1.0),
                              fontSize: 24,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0),
                        ),
                      ))),
            ]));
          },
          onEnd: () {
            handleOnEndAnimate();
          },
        )),
      ]);
    });
  }

  Widget _buildFeedback(Size containerSize) {
    return Center(
      child: Container(
          width: containerSize.width * 0.89,
          height: containerSize.height * 0.5,
          child: Image(
              image: AssetImage(_isRightAnswer
                  ? Constants.imageAssets.happyFace
                  : Constants.imageAssets.sadFace))),
    );
  }

  void _startCamera() {
    widget._viewModel
        .initializeCamera(boundingBoxKey)
        .then((value) => completer.complete());

    widget._viewModel.getMlModelStream().listen((value) {
      //Update results on screen
      _handleCameraPrediction(value.label, value.accuracy, this.context);
    }, onDone: () {}, onError: (error) {});

    setState(() {
      _showingCamera = true;
    });
  }

  void _handleCameraPrediction(
      String label, double confidence, BuildContext ctx) {
    if (!widget._isSpelling) {
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
      // controllerTopCenter.play();
      widget._viewModel.correctAnswers++;
      widget._viewModel.wrongAnswers = 0;

      setState(() {
        widget._progress += widget.progressStep;
      });

      if (widget._viewModel.correctAnswers ==
          (widget._viewModel.maxCorrectAnswers + 1)) {
        print("ENTROU NESSA BAGAÇA");
        handleOnEndAnimate();
      }
    } else {
      widget._viewModel.wrongAnswers++;
      if (widget._viewModel.wrongAnswers == widget._viewModel.maxWrongAnswers) {
        widget._viewModel.correctAnswers = 0;
        setState(() {
          if (widget._progress != 0.0) {
            Utils.showFeedback(FeedbackTypes.error);
          }
          widget._progress = 0.0;
        });
      }
    }
  }

  void _handleCameraPredictionSpelling(
      String newLetter, double confidence, BuildContext ctx) {
    if (widget._viewModel
        .isSpellingCorrect(newLetter, confidence, widget._exercise)) {
      widget._viewModel.correctAnswers++;
      widget._viewModel.wrongAnswers = 0;

      setState(() {
        widget._progress += widget.progressStep;
      });

      if (widget._viewModel.correctAnswers ==
          (widget._viewModel.maxCorrectAnswers + 1)) {
        handleOnEndAnimate();
      }
    } else {
      widget._viewModel.wrongAnswers++;
      if (widget._viewModel.wrongAnswers == widget._viewModel.maxWrongAnswers) {
        widget._viewModel.correctAnswers = 0;
        setState(() {
          if (widget._progress != 0.0) {
            Utils.showFeedback(FeedbackTypes.error);
          }
          widget._progress = 0.0;
        });
      }
    }
  }

  void handleOnEndAnimate() {
    if (widget._viewModel.correctAnswers >=
        widget._viewModel.maxCorrectAnswers) {
      if (widget._isSpelling) {
        setState(() {
          spelledText = widget._viewModel.spelledLetters.join();
        });

        if (spelledText == widget._exercise.correctAnswer) {
          _finishExercise(true);
        } else {
          setState(() {
            widget._progress = 0.0;
          });
        }
      } else {
        setState(() {
          spelledText = widget._exercise.correctAnswer;
          widget._viewModel.correctAnswers = 0;
          widget._viewModel.wrongAnswers = 0;
          widget._progress = 0.0;
        });
        _finishExercise(true);
      }
    }
  }

  void _finishExercise(bool rightAnswer) {
    Utils.showFeedback(
        rightAnswer ? FeedbackTypes.success : FeedbackTypes.error);
    widget.timerHandler.cancelTimer();

    setState(() {
      _finishedExercise = true;
      _isRightAnswer = rightAnswer;
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        widget._viewModel.closeCamera();
        widget._viewModel.showNextArrow();
      });
    });
  }

  void _submitAnswer(BuildContext ctx) {
    widget._viewModel
        .didSubmitTextAnswer(spelledText, widget._exercise.id, this.context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
