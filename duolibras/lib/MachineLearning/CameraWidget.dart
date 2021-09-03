import 'dart:async';

import 'package:camera/camera.dart';
import 'package:duolibras/MachineLearning/TFlite/tflite_helper.dart';
import 'package:flutter/material.dart';

import 'Helpers/app_helper.dart';
import 'Helpers/camera_helper.dart';

// A screen that allows users to take a picture using a given camera.
class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

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

    //Subscribe to TFLite's Classify events
    mlModel.tfLiteResultsController.stream.listen(
        (value) {
          //Update results on screen
          // setState(() {
          //   //Set bit to false to allow detection again
          //   cameraHelper.isDetecting = false;
          // });
        },
        onDone: () {},
        onError: (error) {
          AppHelper.log("listen", error);
        });

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
            return Stack(
              children: <Widget>[CameraPreview(cameraHelper.camera)],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
