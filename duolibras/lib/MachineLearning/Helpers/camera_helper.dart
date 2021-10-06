import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'mlModelProtocol.dart';
import 'app_helper.dart';

class CameraHelper {
  late CameraController _camera;
  CameraController get camera => _camera;

  bool isDetecting = false;
  CameraLensDirection _direction;
  Completer<void> completer = Completer();
  MLModelProtocol mlModel;

  CameraHelper(this.mlModel, this._direction) {
    initializeCamera();

    //Load TFLite Model
    mlModel.loadModel();
  }

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  void initializeCamera() async {
    AppHelper.log("_initializeCamera", "Initializing camera..");

    _camera = CameraController(
        await _getCamera(_direction),
        defaultTargetPlatform == TargetPlatform.iOS
            ? ResolutionPreset.low
            : ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888);

    await _camera.initialize().then((value) {
      AppHelper.log(
          "_initializeCamera", "Camera initialized, starting camera stream..");
      completer.complete();

      _camera.startImageStream((CameraImage image) {
        if (mlModel.modelsIsLoaded && mlModel.isOpen) {
          try {
            mlModel.predict(image);
          } catch (e) {
            print(e);
          }
        } 
      });
    });
  }

  void dispose() {
    _camera.dispose();
  }
}
