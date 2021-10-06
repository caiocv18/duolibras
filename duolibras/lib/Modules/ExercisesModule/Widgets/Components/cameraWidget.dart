import 'dart:async';

import 'package:camera/camera.dart';
import 'package:duolibras/MachineLearning/Helpers/app_helper.dart';
import 'package:duolibras/MachineLearning/Helpers/camera_helper.dart';
import 'package:duolibras/MachineLearning/TFlite/tflite_helper.dart';
import 'package:flutter/material.dart';

import 'TextStream.dart';

// A screen that allows users to take a picture using a given camera.
class CameraWidget extends StatefulWidget {
  final Function _handlerPrediction;
  final String label;
  final List<String> spelledLetters;

  CameraWidget(this.label, this._handlerPrediction, this.spelledLetters);

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  final mlModel = TFLiteHelper();
  late CameraHelper cameraHelper;
  final completer = Completer<void>();

  void initState() {
    super.initState();

    cameraHelper = CameraHelper(mlModel, CameraLensDirection.front);
    cameraHelper.completer.future.then((_) => {completer.complete()});
  }

  @override
  void dispose() {
    mlModel.close();
    cameraHelper.dispose();
    AppHelper.log("dispose", "Clear resources.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<void>(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                CameraPreview(cameraHelper.camera),
                SizedBox(height: 15),
                TextStream(
                    label: widget.label,
                    tfLiteResultsController: mlModel.tfLiteResultsController,
                    handlerPrediction: widget._handlerPrediction)
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
