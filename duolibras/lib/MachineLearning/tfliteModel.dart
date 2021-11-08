import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:download_assets/download_assets.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/MachineLearning/mlModelProtocol.dart';
import 'package:flutter/foundation.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as IL;

import 'Helpers/app_helper.dart';
import 'Helpers/result.dart';

class TFLiteModel extends MLModelProtocol {
  var _outputs = <Result>[];
  final String modelPath;
  final String labelsPath;

  TFLiteModel(this.modelPath, this.labelsPath);

  Future<void> loadModel() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
            model: "${DownloadAssetsController.assetsDir}/$modelPath",
            labels: "${DownloadAssetsController.assetsDir}/$labelsPath",
            useGpuDelegate: false,
            isAsset: false)
        .then((value) {
      print(value == "success");
      if (value == "success") {
        modelsIsLoaded = true;
        isOpen = true;
      }
    });
  }

  void predict(List<IL.Image> images) async {
    if (!isOpen || !modelsIsLoaded || images.isEmpty) return;
    var byteslist = List<Uint8List>.from(images.map((e) => e.getBytes()));

    if (byteslist.isEmpty) {
      return;
    }
    // List<Uint8List> bytes = Utils.tryCast(image.getBytes().toList(), fallback: []);
    try {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: byteslist, // required
          imageHeight: images.first.height,
          imageWidth: images.first.width,
          imageMean: 127.5, // defaults to 127.5
          imageStd: 127.5, // defaults to 127.5
          rotation: 0, // defaults to 90, Android only
          threshold: 0.1, // defaults to 0.1
          asynch: true, // defaults to true
          numResults: 5);

      if (recognitions != null) if (recognitions.isNotEmpty) {
        AppHelper.log(
            "classifyImage", "Results loaded. ${recognitions.length}");

        //Clear previous results
        _outputs.clear();

        recognitions.forEach((element) {
          _outputs.add(Result(
              element['confidence'], element['index'], element['label']));

          AppHelper.log("classifyImage",
              "${element['confidence']} , ${element['index']}, ${element['label']}");
        });
      }
    } catch (e) {
      print(e);
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
