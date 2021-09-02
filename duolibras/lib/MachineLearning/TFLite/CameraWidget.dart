import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'AppHelper.dart';
import 'CameraHelper.dart';
import 'Result.dart';
import 'TFLiteHelper.dart';

// A screen that allows users to take a picture using a given camera.
class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  late List<Result> outputs;
  final cameraHelper = CameraHelper(CameraLensDirection.front);
  final completer = Completer<void>();

  void initState() {
    super.initState();

    //Load TFLite Model
    TFLiteHelper.loadModel().then((value) {
      setState(() {
        TFLiteHelper.modelLoaded = true;
      });
    });

    //Subscribe to TFLite's Classify events
    TFLiteHelper.tfLiteResultsController.stream.listen(
        (value) {
          //Set Results
          outputs = value;

          //Update results on screen
          setState(() {
            //Set bit to false to allow detection again
            cameraHelper.isDetecting = false;
          });
        },
        onDone: () {},
        onError: (error) {
          AppHelper.log("listen", error);
        });

    cameraHelper.initializeControllerFuture.then((_) => {completer.complete()});
  }

  @override
  void dispose() {
    TFLiteHelper.disposeModel();
    cameraHelper.camera.dispose();
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
