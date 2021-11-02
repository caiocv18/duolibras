import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/multiChoiceState.dart';
import 'package:flutter/material.dart';

class MultiChoicesWidget extends StatefulWidget {
  final List<String> _answers;
  Function _handleQuestion;
  final String _correctAnswer;

  MultiChoicesWidget(this._answers, this._correctAnswer, this._handleQuestion);

  @override
  State<MultiChoicesWidget> createState() => _MultiChoicesWidgetState();
}

class _MultiChoicesWidgetState extends State<MultiChoicesWidget> {
  ExerciseScreenState state = ExerciseScreenState.NotAnswered;
  String? selectAnswer = null;

  bool isAnswerCorrect = false;

  Widget _createButton(String title, BoxConstraints constraint) {
    return Column(
      children: [
        Container(
          height: 45,
          width: constraint.maxWidth * 0.7,
          child: ExerciseButton(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Gameplay',
                ),
              ),
            ),
            size: 25,
            color: _getButtonColor(title), //Colors.white, //Color(0xFFCA3034),
            onPressed: () {
              // if (state == ExerciseScreenState.DidAnswer) return;
              setState(() {
                state = ExerciseScreenState.DidAnswer;
                selectAnswer = title;
                isAnswerCorrect = widget._correctAnswer == title;
                widget._handleQuestion(title);
              });
            },
          ),
        ),
        SizedBox(height: constraint.maxHeight * 0.08)
      ],
    );
  }

  Color _getButtonColor(String title) {
    if (state == ExerciseScreenState.NotAnswered) return Colors.blue;

    if (isAnswerCorrect) {
    } else {
      if (selectAnswer == title) {
        return Colors.red;
      } else if (title == widget._correctAnswer) {
        return Colors.green;
      } else {
        return Colors.grey;
      }
    }

    if (selectAnswer == title) {
      return selectAnswer != widget._correctAnswer ? Colors.red : Colors.green;
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
          child: Column(children: [
        ...widget._answers.map((answer) {
          return _createButton(answer, constraint);
        }).toList()
      ]));
    });
  }
}
