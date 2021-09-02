import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/inputAnswerWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseScreen.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';

abstract class ExerciseWritingViewModel {
  void didSubmitTextAnswer(
      String answer, String exerciseID, BuildContext context);

  bool isAnswerCorrect(String answer, String exerciseID);
}

class ExerciseWritingScreen extends ExerciseScreen {
  static String routeName = "/ExerciseWritingScreen";

  final PreferredSizeWidget appBar = AppBarWidget();

  final bottomNavigationBar = BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Container()),
      BottomNavigationBarItem(icon: Icon(Icons.score), title: Container())
    ],
  );

  final inputController = TextEditingController();
  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseWritingScreen(this._exercise, this._viewModel);

  void handleSubmitAnswer(String answer, String correctAnswer,
      String exerciseID, BuildContext ctx) {
    final isCorrect = _viewModel.isAnswerCorrect(answer, exerciseID);

    showFinishExerciseBottomSheet(isCorrect, correctAnswer, ctx, () {
      _viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
    });
  }

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        height: containerSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: containerSize.height * 0.10,
                child: QuestionWidget(exercise.question)),
            Container(
                height: containerSize.height * 0.5,
                child: Image.network(exercise.mediaUrl)),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    height: containerSize.height * 0.1,
                    child: InputAnswerWidget(inputController)),
                SizedBox(height: containerSize.height * 0.03),
                Container(
                  height: containerSize.height * 0.08,
                  width: containerSize.width * 0.7,
                  child: ElevatedButton(
                    child: Text("Verificar"),
                    onPressed: () {
                      handleSubmitAnswer(inputController.text,
                          exercise.correctAnswer, exercise.id, ctx);
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blue)))),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    // final ExerciseViewModel _viewModel = args["viewModel"] as ExerciseViewModel;
    // final Exercise _exercise = args["exercise"] as Exercise;

    final _mediaQuery = MediaQuery.of(context);

    final _containerHeight = _mediaQuery.size.height -
        (kBottomNavigationBarHeight +
            _mediaQuery.padding.bottom +
            appBar.preferredSize.height +
            _mediaQuery.padding.top);
    final _containerWidth = _mediaQuery.size.width;

    final containerSize = Size(_containerWidth, _containerHeight);

    return Scaffold(
        // appBar: AppBarWidget(),
        bottomNavigationBar: bottomNavigationBar,
        body: _buildBody(_exercise, _viewModel, containerSize, context));
  }
}
