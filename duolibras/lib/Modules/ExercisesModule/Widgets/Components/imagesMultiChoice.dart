import 'package:duolibras/Commons/Extensions/color_extension.dart';
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
          padding:
              EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.1),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: size.width * 0.36,
              childAspectRatio: 1.07,
              crossAxisSpacing: size.width * 0.08,
              mainAxisSpacing: size.height * 0.02),
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
    if (state == ExerciseScreenState.NotAnswered)
      return HexColor.fromHex("93CAFA");

    if (didPickCorrectChoice) {
    } else {
      if (selectedAnswer == title) {
        return HexColor.fromHex("E97070");
      } else if (title == widget._correctAnswer) {
        return HexColor.fromHex("64C195");
      } else {
        return Colors.grey;
      }
    }

    if (selectedAnswer == title) {
      return selectedAnswer != widget._correctAnswer
          ? HexColor.fromHex("E97070")
          : HexColor.fromHex("64C195");
    }

    return Colors.grey;
  }
}
