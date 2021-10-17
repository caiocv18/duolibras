import 'dart:async';

import 'package:camera/camera.dart';
import 'package:duolibras/MachineLearning/Helpers/mlModelProtocol.dart';
import 'package:tflite/tflite.dart';

import '../Helpers/app_helper.dart';
import '../Helpers/result.dart';

class TFLiteHelper extends MLModelProtocol {
  var _outputs = <Result>[];

  Future<void> loadModel() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
            model: "assets/model.tflite",
            labels: "assets/labels.txt",
            useGpuDelegate: false)
        .then((value) {
          print(value == "success");
          if (value == "success") {
            modelsIsLoaded = true;
            isOpen = true;        
          }
    });
  }

  void predict(CameraImage image) async {
    if (!isOpen || !modelsIsLoaded) return;
    
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        // model: "SSDMobileNet",
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5, // defaults to 127.5
        imageStd: 127.5, // defaults to 127.5
        rotation: 90, // defaults to 90, Android only
        threshold: 0.1, // defaults to 0.1
        asynch: true, // defaults to true
        numResults: 1);

    if (recognitions != null) if (recognitions.isNotEmpty) {
      AppHelper.log("classifyImage", "Results loaded. ${recognitions.length}");

      //Clear previous results
      _outputs.clear();

      recognitions.forEach((element) {
        _outputs.add(
            Result(element['confidence'], element['index'], element['label']));

        AppHelper.log("classifyImage",
            "${element['confidence']} , ${element['index']}, ${element['label']}");
      });
    }

    // Sort results according to most confidence
    _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));

    // Send results
    if (!tfLiteResultsController.isClosed) {
      tfLiteResultsController.add(_outputs);
    }
  }

  @override
  Future<void> close() async {
    await Tflite.close();
    isOpen = false;
  }

}
