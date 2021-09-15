import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Helpers/app_helper.dart';
import 'Helpers/result.dart';

// A screen that allows users to take a picture using a given camera.
class TextStream extends StatefulWidget {
  final StreamController<List<Result>> tfLiteResultsController;
  const TextStream({required this.tfLiteResultsController, Key? key})
      : super(key: key);

  @override
  TextStreamState createState() => TextStreamState();
}

class TextStreamState extends State<TextStream> {
  var resultText = "";
  var confidenceText = "";

  void initState() {
    super.initState();

    //Subscribe to TFLite's Classify events
    widget.tfLiteResultsController.stream.listen(
        (value) {
          //Update results on screen
          // if (value.first.confidence > 0.70) {
            setState(() {
              resultText = value.first.label;
              confidenceText = "${value.first.confidence}";
            });
          // }
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
        resultText,
        style: TextStyle(fontSize: 20),
      ),
      Text(confidenceText, style: TextStyle(fontSize: 15))
    ]));
  }
}
