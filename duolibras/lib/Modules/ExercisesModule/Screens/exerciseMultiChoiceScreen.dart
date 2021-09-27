import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/imagesMultiChoice.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/midiaWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/multiChoicesWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseScreen.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ExercisesCategory.dart';
import 'package:flutter/material.dart';

class ExerciseMultiChoiceScreen extends ExerciseScreen {
  static String routeName = "/ExerciseMultiChoiceScreen";

  final PreferredSizeWidget appBar = AppBarWidget();

  final bottomNavigationBar = BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Container()),
      BottomNavigationBarItem(icon: Icon(Icons.score), title: Container())
    ],
  );

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseMultiChoiceScreen(this._exercise, this._viewModel);

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
            handleSubmitAnswer(
                answer, exercise.correctAnswer, exercise.id, ctx);
          })
        : ImagesMultiChoice(exercise.answers, (answer) {
            handleSubmitAnswer(
                answer, exercise.correctAnswer, exercise.id, ctx);
          });
  }

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return Container(
      color: Color.fromRGBO(234, 234, 234, 1),
      child: SafeArea(
          child: Container(
        color: Color.fromRGBO(234, 234, 234, 1),
        height: containerSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: containerSize.height * 0.10,
                child: QuestionWidget(exercise.question)),
            Container(
                height: containerSize.height * 0.37,
                width: containerSize.width * 0.54,
                child: Midiawidget(exercise.mediaUrl)),
            SizedBox(height: 34),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    height: containerSize.height * 0.40,
                    child: _createMultiChoiceWidget(exercise, ctx)),
              ],
            ),
            SizedBox(height: containerSize.height * 0.05)
          ],
        ),
      )),
    );
  }

  void handleSubmitAnswer(String answer, String correctAnswer,
      String exerciseID, BuildContext ctx) {
    final isCorrect = _viewModel.isAnswerCorrect(answer, exerciseID);
    if (_exercise.category == ExercisesCategory.multipleChoicesText) {
      showFinishExerciseBottomSheet(isCorrect, correctAnswer, ctx, () {
        _viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
      });
    } else {
      showFinishExerciseBottomSheetWithImage(isCorrect, correctAnswer, ctx, () {
        _viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    // final ExerciseViewModel viewModel = args["viewModel"] as ExerciseViewModel;
    // final Exercise exercise = args["exercise"] as Exercise;

    final _mediaQuery = MediaQuery.of(context);

    final containerHeight =
        _mediaQuery.size.height - (appBar.preferredSize.height + 98);
    // (kBottomNavigationBarHeight +
    //     _mediaQuery.padding.bottom +
    //     // appBar.preferredSize.height +
    //     _mediaQuery.padding.top +
    //     70);

    final containerSize = Size(_mediaQuery.size.width, containerHeight);

    return Scaffold(
        // appBar: AppBarWidget(),
        // drawer: AppBarWidget(),
        extendBodyBehindAppBar: true,
        extendBody: true,
        // bottomNavigationBar: bottomNavigationBar,
        body: _buildBody(_exercise, _viewModel, containerSize, context));
  }
}
