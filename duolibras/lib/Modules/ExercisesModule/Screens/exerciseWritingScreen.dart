import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/multiChoiceState.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/inputAnswerWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/midiaWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseScreen.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ExerciseWritingScreen extends ExerciseStateful {
  static String routeName = "/ExerciseWritingScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseWritingScreen(this._exercise, this._viewModel);

  @override
  State<ExerciseWritingScreen> createState() => _ExerciseWritingScreenState();
}

class _ExerciseWritingScreenState extends State<ExerciseWritingScreen> {
  ExerciseScreenState _state = ExerciseScreenState.NotAnswered;
  var didAnswerCorrect = null;
  var isKeyboardActive = false;
  final inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.handleNextExercise = () {
      handleSubmitAnswer(inputController.text, widget._exercise.correctAnswer,
          widget._exercise.id, this.context);
    };

    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardActive = visible;
      });
    });
  }

  void handleSubmitAnswer(String answer, String correctAnswer,
      String exerciseID, BuildContext ctx) {
    widget._viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
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
        body: _buildBody(
            widget._exercise, widget._viewModel, containerSize, context));
  }

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return Container(
      height: containerSize.height,
      color: Color.fromRGBO(234, 234, 234, 1),
      child: Container(
        height: containerSize.height,
        child: SingleChildScrollView(
          physics: isKeyboardActive ? null : NeverScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: containerSize.height * 0.10,
                  child: QuestionWidget(exercise.question ?? "")),
              SizedBox(
                height: containerSize.height * 0.05,
              ),
              Container(
                  height: containerSize.height * 0.35,
                  width: containerSize.width * 0.54,
                  child: Midiawidget(exercise.mediaUrl)),
              SizedBox(
                height: containerSize.height * 0.05,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      height: containerSize.height * 0.1,
                      child: InputAnswerWidget(
                          inputController,
                          _state == ExerciseScreenState.NotAnswered,
                          "Sua Resposta")),
                  SizedBox(height: containerSize.height * 0.05),
                  Container(
                      height: containerSize.height * 0.08,
                      width: containerSize.width * 0.7,
                      child: ExerciseButton(
                        child: Center(
                          child: Text(
                            "Verificar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'Gameplay',
                            ),
                          ),
                        ),
                        size: 25,
                        color: (didAnswerCorrect == null)
                            ? Colors.grey
                            : didAnswerCorrect
                                ? Colors.green
                                : Colors
                                    .red, //Colors.white, //Color(0xFFCA3034),
                        onPressed: () {
                          if (_state == ExerciseScreenState.DidAnswer) return;
                          setState(() {
                            _state = ExerciseScreenState.DidAnswer;
                            didAnswerCorrect = widget._viewModel
                                .isAnswerCorrect(
                                    inputController.text, widget._exercise.id);
                            widget._viewModel.showNextArrow();
                          });
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
