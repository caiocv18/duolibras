import 'dart:async';
import 'package:camera/camera.dart';
import 'package:duolibras/MachineLearning/Helpers/yuv_channeling.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IL;

import 'mlModelProtocol.dart';
import 'Helpers/app_helper.dart';

class MLCamera {
  bool isDetecting = false;
  CameraLensDirection _direction;
  var isAvailable = true;
  MLModelProtocol _mlModel;
  MLModelProtocol get mlModel => _mlModel;
  late CameraController _camera;
  CameraController get camera => _camera;
  HandDirection? _boxDirection;
  final imageProcessor = YuvChannelling();

  MLCamera(this._mlModel, this._direction) {}

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  Future<void> initializeCamera(GlobalKey key) async {
    AppHelper.log("_initializeCamera", "Initializing camera..");

    _camera = CameraController(
        await _getCamera(_direction),
        defaultTargetPlatform == TargetPlatform.iOS
            ? ResolutionPreset.high
            : ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);

    return await _camera.initialize().then((value) {
      AppHelper.log(
          "_initializeCamera", "Camera initialized, starting camera stream..");
      mlModel.loadModel();

      _camera.startImageStream((CameraImage image) async {
        try {
          if (isAvailable) {
            isAvailable = false;
            mlModel.predict(defaultTargetPlatform == TargetPlatform.iOS
                ? _handleIOSImage(image).first
                : ((await _handleAndroidImage(image)) ?? IL.Image(0, 0)));
            Future.delayed(Duration(milliseconds: 500))
                .then((_) => isAvailable = true);
          }
        } catch (e) {
          print(e);
        }
      });
    });
  }

  void setBoxDirection(HandDirection? direction) {
    this._boxDirection = direction;
  }

  Future<IL.Image?> _handleAndroidImage(CameraImage image) async {
    if (_boxDirection == null) {
      return null;
    }

    try {
      final imgBytes = await imageProcessor.yuv_transform(image);
      var img = IL.decodeJpg(imgBytes);

      img = IL.flipVertical(img);

      if (_boxDirection == HandDirection.LEFT) {
        img = IL.flipHorizontal(img);
      }

      img = IL.copyCrop(
          img,
          (img.width * 0.53).toInt(),
          (img.height * 0.47).toInt(),
          (img.width * 0.47).toInt(),
          (img.height * 0.34).toInt());

      return img;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
      return null;
    }
  }

  List<IL.Image> _handleIOSImage(CameraImage image) {
    if (_boxDirection == null) {
      return [];
    }

    var croppedImages = image.planes.map((e) {
      var ci = IL.Image.fromBytes(
        image.width,
        image.height,
        image.planes[0].bytes,
        format: IL.Format.bgra,
      );

      if (_boxDirection == HandDirection.LEFT) {
        ci = IL.flipHorizontal(ci);
      }

      ci = IL.copyCrop(
          ci,
          (image.width * 0.53).toInt(),
          (image.height * 0.47).toInt(),
          (image.width * 0.5).toInt(),
          (image.width * 0.6).toInt());

      return ci;
    }).toList();

    return croppedImages;
  }

  Future<void> close() async {
    try {
      await _camera.pausePreview();
      await _camera.stopImageStream();
    } catch (e) {
      print(e);
    }
  }
}
