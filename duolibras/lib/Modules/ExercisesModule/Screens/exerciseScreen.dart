import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/midiaWidget.dart';
import 'package:flutter/material.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';

abstract class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  void showFinishExerciseBottomSheet(bool isAnswerCorrect, String correctAnswer,
      BuildContext context, Function handler) {
    final button = ExerciseButton(
      child: Center(
        child: Text(
          "Continuar",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Gameplay',
          ),
        ),
      ),
      size: 25,
      color: HexColor.fromHex("#D2D7E4"), //Colors.white, //Color(0xFFCA3034),
      onPressed: () {
        handler();
      },
    );

    final msg = isAnswerCorrect
        ? "Incrível!"
        : "A resposta correta é ${correctAnswer}!";

    final backgroundColor = isAnswerCorrect
        ? HexColor.fromHex("#64C195")
        : HexColor.fromHex("#E97070");

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 5)]),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      msg,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    button
                  ])),
            ));
  }

  void showFinishExerciseBottomSheetWithImage(bool isAnswerCorrect,
      String correctAnswerUrl, BuildContext context, Function handler) {
    final button = ExerciseButton(
      child: Center(
        child: Text(
          "Continuar",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Gameplay',
          ),
        ),
      ),
      size: 25,
      color: HexColor.fromHex("#D2D7E4"), //Colors.white, //Color(0xFFCA3034),
      onPressed: () {
        handler();
      },
    );

    final msg = isAnswerCorrect ? "Incrível!" : "A resposta correta é:";

    final backgroundColor = isAnswerCorrect
        ? HexColor.fromHex("#64C195")
        : HexColor.fromHex("#E97070");

    final size = MediaQuery.of(context).size; //.size.height * 0.18;

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: isAnswerCorrect ? size.height * 0.18 : size.height * 0.25,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 5)]),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      msg,
                      style: TextStyle(fontSize: 25),
                    ),
                    if (!isAnswerCorrect) ...[
                      SizedBox(height: 20),
                      Image.network(correctAnswerUrl,
                          height: size.height * 0.1),
                    ],
                    SizedBox(height: size.height * 0.03),
                    button
                  ])),
            ));
  }
}

abstract class ExerciseStateful extends StatefulWidget {
  void showFinishExerciseBottomSheet(bool isAnswerCorrect, String correctAnswer,
      BuildContext context, Function handler) {
    final button = ExerciseButton(
      child: Center(
        child: Text(
          "Continuar",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Gameplay',
          ),
        ),
      ),
      size: 25,
      color: HexColor.fromHex("#D2D7E4"), //Colors.white, //Color(0xFFCA3034),
      onPressed: () {
        handler();
      },
    );

    ElevatedButton(
      child: Text("Continuar"),
      onPressed: () {
        handler();
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue)))),
    );

    final msg = isAnswerCorrect
        ? "Incrível!"
        : "A resposta correta é ${correctAnswer}!";

    final backgroundColor = isAnswerCorrect
        ? HexColor.fromHex("#64C195")
        : HexColor.fromHex("#E97070");

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 5)]),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      msg,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    button
                  ])),
            ));
  }

  void showFinishExerciseBottomSheetWithImage(bool isAnswerCorrect,
      String correctAnswerUrl, BuildContext context, Function handler) {
    final button = ExerciseButton(
      child: Center(
        child: Text(
          "Continuar",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Gameplay',
          ),
        ),
      ),
      size: 25,
      color: HexColor.fromHex("#D2D7E4"), //Colors.white, //Color(0xFFCA3034),
      onPressed: () {
        handler();
      },
    );

    final msg = isAnswerCorrect ? "Incrível!" : "A resposta correta é:";

    final backgroundColor = isAnswerCorrect
        ? HexColor.fromHex("#64C195")
        : HexColor.fromHex("#E97070");

    final size = MediaQuery.of(context).size; //.size.height * 0.18;

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: isAnswerCorrect ? size.height * 0.18 : size.height * 0.29,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [BoxShadow(blurRadius: 10, spreadRadius: 5)]),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      msg,
                      style: TextStyle(fontSize: 25),
                    ),
                    if (!isAnswerCorrect) ...[
                      SizedBox(height: 20),
                      Container(
                        width: size.width * 0.22,
                        height: size.height * 0.1,
                        child: Midiawidget(correctAnswerUrl),
                      )
                    ],
                    SizedBox(height: size.height * 0.03),
                    button
                  ])),
            ));
  }
}
