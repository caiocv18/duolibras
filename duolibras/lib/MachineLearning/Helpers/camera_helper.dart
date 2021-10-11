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
            ? ResolutionPreset.medium
            : ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420);

    await _camera.initialize().then((value) {
      AppHelper.log("_initializeCamera", "Camera initialized, starting camera stream..");
      mlModel.loadModel();
      completer.complete();

      _camera.startImageStream((CameraImage image) {
        try {
          mlModel.predict(image);
        } catch (e) {
          print(e);
        }
      });
    });
  }

  Future<void> close() async {
    await _camera.stopImageStream();
    await _camera.dispose();
  }

}
