import 'dart:ui';

import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/multiChoiceState.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/imagesMultiChoice.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/midiaWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/multiChoicesWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseScreen.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/exercisesCategory.dart';
import 'package:flutter/material.dart';

class ExerciseMultiChoiceScreen extends ExerciseStateful {
  static String routeName = "/ExerciseMultiChoiceScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseMultiChoiceScreen(this._exercise, this._viewModel);

  @override
  State<ExerciseMultiChoiceScreen> createState() =>
      _ExerciseMultiChoiceScreenState();

  @override
  Function? handleNextExercise;
}

class _ExerciseMultiChoiceScreenState extends State<ExerciseMultiChoiceScreen> {
  ExerciseScreenState _state = ExerciseScreenState.NotAnswered;
  var answerPicked = "";

  @override
  void initState() {
    widget.handleNextExercise = () {
      handleSubmitAnswer(answerPicked, widget._exercise.correctAnswer,
          widget._exercise.id, this.context);
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
              child: _buildBody(widget._exercise, widget._viewModel,
                  Size(constraint.maxWidth, constraint.maxHeight), context),
            );
          })),
    ]));
  }

  Widget _createMultiChoiceWidget(Exercise exercise, BuildContext ctx) {
    return exercise.category == ExercisesCategory.multipleChoicesText
        ? MultiChoicesWidget(exercise.answers ?? [], exercise.correctAnswer,
            (answer) {
            // if (_state == ExerciseScreenState.DidAnswer) return;
            final answerIsCorrect =
                widget._viewModel.isAnswerCorrect(answer, widget._exercise.id);
            setState(() {
              _state = ExerciseScreenState.DidAnswer;
              answerPicked = answer;
              Utils.showFeedback(answerIsCorrect
                  ? FeedbackTypes.success
                  : FeedbackTypes.error);
              widget._viewModel.showNextArrow();
            });
          })
        : ImagesMultiChoice(exercise.answers ?? [], exercise.correctAnswer,
            (answer) {
            if (_state == ExerciseScreenState.DidAnswer) return;
            final answerIsCorrect =
                widget._viewModel.isAnswerCorrect(answer, widget._exercise.id);
            setState(() {
              _state = ExerciseScreenState.DidAnswer;
              answerPicked = answer;
              Utils.showFeedback(answerIsCorrect
                  ? FeedbackTypes.success
                  : FeedbackTypes.error);
              widget._viewModel.showNextArrow();
            });
          });
  }

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            // height: containerSize.height * 0.08,
            width: containerSize.width * 0.95,
            child: QuestionWidget(exercise.question ?? "")),
        SizedBox(height: containerSize.height * 0.05),
        Container(
            height: containerSize.height * 0.3,
            width: containerSize.width * 0.45,
            child: Midiawidget(exercise.mediaUrl)),
        SizedBox(height: containerSize.height * 0.05),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                height: containerSize.height * 0.6,
                child: _createMultiChoiceWidget(exercise, ctx)),
          ],
        ),
        SizedBox(height: containerSize.height * 0.1),
      ],
    );
  }

  void handleSubmitAnswer(String answer, String correctAnswer,
      String exerciseID, BuildContext ctx) {
    if (widget._exercise.category == ExercisesCategory.multipleChoicesText) {
      widget._viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
    } else {
      widget._viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
    }
  }
}
