import 'dart:ui';

import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Commons/Components/exerciseAppBarWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/multiChoiceState.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/imagesMultiChoice.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/midiaWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/multiChoicesWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseScreen.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ExercisesCategory.dart';
import 'package:flutter/material.dart';

class ExerciseMultiChoiceScreen extends ExerciseStateful {
  static String routeName = "/ExerciseMultiChoiceScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseMultiChoiceScreen(this._exercise, this._viewModel);

  @override
  State<ExerciseMultiChoiceScreen> createState() =>
      _ExerciseMultiChoiceScreenState();
}

class _ExerciseMultiChoiceScreenState extends State<ExerciseMultiChoiceScreen> {
  final PreferredSizeWidget appBar = AppBarWidget();

  ExerciseScreenState _state = ExerciseScreenState.NotAnswered;
  var answerPicked = "";

  Widget _buildPopupDialog(BuildContext context, String title) {
    return new AlertDialog(
      title: Text(title),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _createMultiChoiceWidget(Exercise exercise, BuildContext ctx) {
    return exercise.category == ExercisesCategory.multipleChoicesText
        ? MultiChoicesWidget(exercise.answers, exercise.correctAnswer,
            (answer) {
            if (_state == ExerciseScreenState.DidAnswer) return;

            setState(() {
              _state = ExerciseScreenState.DidAnswer;
              answerPicked = answer;
              handleSubmitAnswer(
                  answer, exercise.correctAnswer, exercise.id, ctx);
            });
          })
        : ImagesMultiChoice(exercise.answers, exercise.correctAnswer, (answer) {
            if (_state == ExerciseScreenState.DidAnswer) return;

            setState(() {
              _state = ExerciseScreenState.DidAnswer;
              answerPicked = answer;
              handleSubmitAnswer(
                  answer, exercise.correctAnswer, exercise.id, ctx);
            });
          });
  }

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return Container(
      width: double.infinity,
      color: Color.fromRGBO(234, 234, 234, 1),
      child: SafeArea(
          child: Container(
        color: Color.fromRGBO(234, 234, 234, 1),
        // height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: containerSize.height * 0.08,
                width: containerSize.width * 0.95,
                child: QuestionWidget(exercise.question)),
            SizedBox(height: containerSize.height * 0.05),
            Container(
                height: containerSize.height * 0.35,
                width: containerSize.width * 0.54,
                child: Midiawidget(exercise.mediaUrl)),
            SizedBox(height: containerSize.height * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    height: containerSize.height * 0.42,
                    child: _createMultiChoiceWidget(exercise, ctx)),
              ],
            ),
            SizedBox(height: containerSize.height * 0.05),
          ],
        ),
      )),
    );
  }

  void handleSubmitAnswer(String answer, String correctAnswer,
      String exerciseID, BuildContext ctx) {
    final isCorrect = widget._viewModel.isAnswerCorrect(answer, exerciseID);
    if (widget._exercise.category == ExercisesCategory.multipleChoicesText) {
      widget.showFinishExerciseBottomSheet(isCorrect, correctAnswer, ctx, () {
        widget._viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
      });
    } else {
      widget.showFinishExerciseBottomSheetWithImage(
          isCorrect, correctAnswer, ctx, () {
        widget._viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBarHeight = ExerciseAppBarWidget.appBarHeight;
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight = mediaQuery.size.height - (appBarHeight + paddingTop + mediaQuery.padding.bottom);
    final containerSize = Size(mediaQuery.size.width, containerHeight);

    return Scaffold(
        bottomNavigationBar: _state == ExerciseScreenState.DidAnswer
            ? BottomAppBar(
                color: Color.fromRGBO(234, 234, 234, 1),
                child: GestureDetector(
                  child: Icon(Icons.arrow_circle_up_rounded),
                  onVerticalDragStart: (_) {
                    handleSubmitAnswer(
                        answerPicked,
                        widget._exercise.correctAnswer,
                        widget._exercise.id,
                        context);
                  },
                ),
                elevation: 0,
              )
            : null,
        body: _buildBody(widget._exercise, widget._viewModel, containerSize, context));
  }
}
