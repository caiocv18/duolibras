import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/multiChoiceState.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/inputAnswerWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/midiaWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseScreen.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:flutter/material.dart';

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
  final inputController = TextEditingController();

  @override
  void initState() {
    widget.handleNextExercise = () {
      handleSubmitAnswer(inputController.text, widget._exercise.correctAnswer,
          widget._exercise.id, this.context);
    };

    super.initState();
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
        resizeToAvoidBottomInset: false,
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
              child: Container(
                height: containerSize.height,
                width: double.infinity,
                child: _buildBody(widget._exercise, widget._viewModel,
                    containerSize, context),
              ))
        ]));
  }

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        height: containerSize.height,
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
                              : Colors.red, //Colors.white, //Color(0xFFCA3034),
                      onPressed: () {
                        if (_state == ExerciseScreenState.DidAnswer) return;
                        setState(() {
                          _state = ExerciseScreenState.DidAnswer;
                          didAnswerCorrect = widget._viewModel.isAnswerCorrect(
                              inputController.text.toUpperCase().trim(),
                              widget._exercise.id);
                          widget._viewModel.showNextArrow();
                        });
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
