import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/cameraWidget.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/questionWidget.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:flutter/material.dart';
import 'exerciseScreen.dart';

class ExerciseMLScreen extends ExerciseStateful {
  static String routeName = "/ExerciseMLScreen";

  final ExerciseViewModel _viewModel;
  final Exercise _exercise;

  ExerciseMLScreen(this._exercise, this._viewModel);

  @override
  _ExerciseMLScreenState createState() => _ExerciseMLScreenState();
}

class _ExerciseMLScreenState extends State<ExerciseMLScreen> {
  var _showingCamera = false;

  Widget showQuestionBody(Exercise exercise, ExerciseViewModel viewModel,
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
            SizedBox(height: 15),
            Container(
              height: containerSize.height * 0.08,
              width: containerSize.width * 0.7,
              child: ElevatedButton(
                child: Text("Abrir a Câmera"),
                onPressed: () {
                  setState(() {
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
        ),
      ),
    ));
  }

  void _handleCameraPrediction(
      String label, double confidence, BuildContext ctx) {
    if (widget._viewModel
        .isGestureCorrect(label, confidence, widget._exercise)) {
      setState(() {
        _showingCamera = false;
        widget.showFinishExerciseBottomSheet(
            true, widget._exercise.correctAnswer, ctx, () {
          widget._viewModel
              .didSubmitTextAnswer(label, widget._exercise.id, ctx);
        });
      });
    }
  }

  Widget cameraBody(Exercise exercise, Size containerSize, BuildContext ctx) {
    return Container(
        child: CameraWidget(
            exercise.correctAnswer,
            (label, confidence) =>
                _handleCameraPrediction(label, confidence, ctx)));
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    final _containerHeight = _mediaQuery.size.height -
        (kBottomNavigationBarHeight +
            _mediaQuery.padding.bottom +
            50 +
            _mediaQuery.padding.top);
    final _containerWidth = _mediaQuery.size.width;

    final containerSize = Size(_containerWidth, _containerHeight);

    return Scaffold(
        body: _showingCamera
            ? cameraBody(widget._exercise, containerSize, context)
            : showQuestionBody(
                widget._exercise, widget._viewModel, containerSize, context));
  }
}
