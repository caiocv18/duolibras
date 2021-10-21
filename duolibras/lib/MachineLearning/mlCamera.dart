import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'mlModelProtocol.dart';
import 'Helpers/app_helper.dart';

class MLCamera {
  bool isDetecting = false;
  CameraLensDirection _direction;
  
  MLModelProtocol _mlModel;
  MLModelProtocol get mlModel => _mlModel;

  late CameraController _camera;
  CameraController get camera => _camera;

  MLCamera(this._mlModel, this._direction) {}

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  Future<void> initializeCamera() async {
    AppHelper.log("_initializeCamera", "Initializing camera..");

    _camera = CameraController(
        await _getCamera(_direction),
        defaultTargetPlatform == TargetPlatform.iOS
            ? ResolutionPreset.medium
            : ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420);

    return await _camera.initialize().then((value) {
      AppHelper.log("_initializeCamera", "Camera initialized, starting camera stream..");
      mlModel.loadModel();

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
