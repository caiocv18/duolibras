import 'package:duolibras/Modules/ExercisesModule/ViewModel/multiChoiceState.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/imageChoiceItem.dart';
import 'package:flutter/material.dart';

class ImagesMultiChoice extends StatefulWidget {
  final List<String> _answersUrl;
  Function _handleQuestion;
  final String _correctAnswer;

  ImagesMultiChoice(
      this._answersUrl, this._correctAnswer, this._handleQuestion);

  @override
  State<ImagesMultiChoice> createState() => _ImagesMultiChoiceState();
}

class _ImagesMultiChoiceState extends State<ImagesMultiChoice> {
  ExerciseScreenState state = ExerciseScreenState.NotAnswered;
  var didPickCorrectChoice = false;
  var selectedAnswer = "";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: GridView(
          shrinkWrap: true,
          primary: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(25),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: size.width/2,
              childAspectRatio: 1.07,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          children: [
            ...widget._answersUrl.map((imageUrl) {
              return ImageChoiceItem(imageUrl, _getButtonColor(imageUrl),
                  (answer) {
                setState(() {
                  state = ExerciseScreenState.DidAnswer;
                  selectedAnswer = answer;
                  didPickCorrectChoice = widget._correctAnswer == answer;
                  widget._handleQuestion(answer);
                });
              });
            }).toList()
          ]),
    );
  }

  Color _getButtonColor(String title) {
    if (state == ExerciseScreenState.NotAnswered) return Colors.blue;

    if (didPickCorrectChoice) {
    } else {
      if (selectedAnswer == title) {
        return Colors.red;
      } else if (title == widget._correctAnswer) {
        return Colors.green;
      } else {
        return Colors.grey;
      }
    }

    if (selectedAnswer == title) {
      return selectedAnswer != widget._correctAnswer
          ? Colors.red
          : Colors.green;
    }

    return Colors.grey;
  }
}
