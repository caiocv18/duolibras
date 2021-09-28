import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/multiChoiceState.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/inputAnswerWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/midiaWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Screens/exerciseScreen.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';

abstract class ExerciseWritingViewModel {
  void didSubmitTextAnswer(
      String answer, String exerciseID, BuildContext context);

  bool isAnswerCorrect(String answer, String exerciseID);
}

class ExerciseWritingScreen extends ExerciseStateful {
  static String routeName = "/ExerciseWritingScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseWritingScreen(this._exercise, this._viewModel);

  @override
  State<ExerciseWritingScreen> createState() => _ExerciseWritingScreenState();
}

class _ExerciseWritingScreenState extends State<ExerciseWritingScreen> {
  final PreferredSizeWidget appBar = AppBarWidget();

  ExerciseScreenState _state = ExerciseScreenState.NotAnswered;
  var didAnswerCorrect = null;
  final inputController = TextEditingController();

  void handleSubmitAnswer(String answer, String correctAnswer,
      String exerciseID, BuildContext ctx) {
    didAnswerCorrect = widget._viewModel.isAnswerCorrect(answer, exerciseID);

    widget.showFinishExerciseBottomSheet(didAnswerCorrect, correctAnswer, ctx,
        () {
      widget._viewModel.didSubmitTextAnswer(answer, exerciseID, ctx);
    });
  }

  Widget _buildBody(Exercise exercise, ExerciseViewModel viewModel,
      Size containerSize, BuildContext ctx) {
    return Container(
      height: double.infinity,
      color: Color.fromRGBO(234, 234, 234, 1),
      child: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(234, 234, 234, 1),
          height: containerSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: containerSize.height * 0.10,
                  child: QuestionWidget(exercise.question)),
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
                      child: InputAnswerWidget(inputController,
                          _state == ExerciseScreenState.NotAnswered)),
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
                            handleSubmitAnswer(inputController.text,
                                exercise.correctAnswer, exercise.id, ctx);
                          });
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    final _containerHeight = _mediaQuery.size.height -
        (kBottomNavigationBarHeight +
            _mediaQuery.padding.bottom +
            appBar.preferredSize.height +
            _mediaQuery.padding.top);
    final _containerWidth = _mediaQuery.size.width;

    final containerSize = Size(_containerWidth, _containerHeight);

    return Scaffold(
        body: _buildBody(
            widget._exercise, widget._viewModel, containerSize, context),
        bottomNavigationBar: _state == ExerciseScreenState.DidAnswer
            ? BottomAppBar(
                color: Color.fromRGBO(234, 234, 234, 1),
                child: GestureDetector(
                  child: Icon(Icons.arrow_circle_up_rounded),
                  onVerticalDragStart: (_) {
                    handleSubmitAnswer(
                        inputController.text,
                        widget._exercise.correctAnswer,
                        widget._exercise.id,
                        context);
                  },
                ),
                elevation: 0,
              )
            : null);
  }
}
