import 'dart:async';

import 'package:duolibras/MachineLearning/Helpers/app_helper.dart';
import 'package:duolibras/MachineLearning/Helpers/result.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class TextStream extends StatefulWidget {
  final StreamController<List<Result>> tfLiteResultsController;
  final Function handlerPrediction;
  final String label;

  const TextStream(
      {required this.label,
      required this.tfLiteResultsController,
      required this.handlerPrediction,
      Key? key})
      : super(key: key);

  @override
  TextStreamState createState() => TextStreamState();
}

class TextStreamState extends State<TextStream> {
  var resultText = "";
  double confidence = 0.0;

  void initState() {
    super.initState();

    //Subscribe to TFLite's Classify events
    widget.tfLiteResultsController.stream.listen(
        (value) {
          //Update results on screen
          setState(() {
            resultText = value.first.label;
            confidence = value.first.confidence;
            print("Result Text: ${resultText}, confidence${confidence}");
            widget.handlerPrediction(resultText, value.first.confidence);
          });
        },
        onDone: () {},
        onError: (error) {
          AppHelper.log("listen", error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Text(
        "Faça a letra ${widget.label}",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      SizedBox(height: 15),
      Container(
        width: 250,
        height: 25,
        alignment: Alignment.center,
        child: LinearProgressIndicator(
            backgroundColor: Colors.grey[600],
            valueColor: AlwaysStoppedAnimation<Color>(
                widget.label != resultText ? Colors.red : Colors.green),
            minHeight: 20,
            value: resultText == "Neutro" ? 0.0 : confidence),
      ),
    ]));
  }
}
