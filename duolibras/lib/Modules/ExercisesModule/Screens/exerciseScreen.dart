import 'package:flutter/material.dart';

abstract class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  void showFinishExerciseBottomSheet(bool isAnswerCorrect, String correctAnswer,
      BuildContext context, Function handler) {
    final button = ElevatedButton(
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

    final backgroundColor =
        isAnswerCorrect ? Colors.green[400] : Colors.red[300];

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 200,
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
                    SizedBox(height: 20),
                    button
                  ])),
            ));
  }
}

abstract class ExerciseStateful extends StatefulWidget {
  void showFinishExerciseBottomSheet(bool isAnswerCorrect, String correctAnswer,
      BuildContext context, Function handler) {
    final button = ElevatedButton(
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

    final backgroundColor =
        isAnswerCorrect ? Colors.green[400] : Colors.red[300];

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 200,
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
                    SizedBox(height: 20),
                    button
                  ])),
            ));
  }
}
