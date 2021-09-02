import 'dart:async';

import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

import 'AppHelper.dart';
import 'Result.dart';

class TFLiteHelper {
  static StreamController<List<Result>> tfLiteResultsController =
      new StreamController.broadcast();
  static List<Result> _outputs = List<Result>.empty();
  static var modelLoaded = false;

  static Future<String?> loadModel() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
        model: "lib/Assets/Files/resnetmodel.tflite",
        labels: "lib/Assets/Files/labels.txt",
        useGpuDelegate: true);
  }

  static classifyImage(CameraImage image) async {
    await Tflite.runModelOnFrame(
            bytesList: image.planes.map((plane) {
      return plane.bytes;
    }).toList())
        .then((value) {
      if (value != null && value.isNotEmpty) {
        AppHelper.log("classifyImage", "Results loaded. ${value.length}");

        //Clear previous results
        _outputs.clear();

        value.forEach((element) {
          _outputs.add(Result(
              element['confidence'], element['index'], element['label']));

          AppHelper.log("classifyImage",
              "${element['confidence']} , ${element['index']}, ${element['label']}");
        });
      }

      //Sort results according to most confidence
      _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));

      //Send results
      tfLiteResultsController.add(_outputs);
    });

    // var result = await Tflite.runPoseNetOnFrame(
    //     bytesList: image.planes.map((plane) {
    //       return plane.bytes;
    //     }).toList(), // required
    //     imageHeight: image.height, // defaults to 1280
    //     imageWidth: image.width, // defaults to 720
    //     imageMean: 125.0, // defaults to 125.0
    //     imageStd: 125.0, // defaults to 125.0
    //     rotation: 90, // defaults to 90, Android only
    //     numResults: 2, // defaults to 5
    //     threshold: 0.7, // defaults to 0.5
    //     nmsRadius: 10, // defaults to 20
    //     asynch: true // defaults to true
    //     );

    // return result;
  }

  static void disposeModel() {
    Tflite.close();
    tfLiteResultsController.close();
  }
}
