import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/multiChoicesWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';

class ExerciseMultiChoiceScreen extends StatelessWidget {
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

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      double containerHeight, BuildContext ctx) {
    return SafeArea(
        child: Container(
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: containerHeight * 0.10,
              child: QuestionWidget(exercise.question)),
          Container(
              height: containerHeight * 0.5,
              child: Image.network(exercise.mediaUrl)),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  height: containerHeight * 0.40,
                  child: MultiChoicesWidget(exercise.answers, (answer) {
                    final title = exercise.correctAnswer == answer
                        ? "Congrats, you are not stupid"
                        : "You are a such idiot";

                    viewModel.didSubmitTextAnswer(answer, exercise.id, ctx);
                  })),
            ],
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    // final ExerciseViewModel viewModel = args["viewModel"] as ExerciseViewModel;
    // final Exercise exercise = args["exercise"] as Exercise;

    final _mediaQuery = MediaQuery.of(context);

    final containerHeight = _mediaQuery.size.height -
        (kBottomNavigationBarHeight +
            _mediaQuery.padding.bottom +
            appBar.preferredSize.height +
            _mediaQuery.padding.top +
            60);

    return Scaffold(
        // appBar: AppBarWidget(),
        // drawer: AppBarWidget(),
        bottomNavigationBar: bottomNavigationBar,
        body: _buildBody(_exercise, _viewModel, containerHeight, context));
  }
}
