import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IL;
import 'package:path_provider/path_provider.dart';

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
        await _getCamera(_direction), ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420);

    return await _camera.initialize().then((value) {
      AppHelper.log(
          "_initializeCamera", "Camera initialized, starting camera stream..");
      mlModel.loadModel();

      _camera.startImageStream((CameraImage image) {
        try {
          if (isAvailable) {
            isAvailable = false;
            mlModel.predict(defaultTargetPlatform == TargetPlatform.iOS
                ? _handleIOSImage(image)
                : _handleAndroidImage(image));
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

  List<IL.Image> _handleAndroidImage(CameraImage image) {
    if (_boxDirection == null) {
      return [];
    }
    const int shift = (0xFF << 24);

    var croppedImages = image.planes.map((e) {
      var ci = IL.Image.fromBytes(
        image.width,
        image.height,
        image.planes[0].bytes,
        format: IL.Format.bgra,
      );

      for (int x = 0; x < image.width; x++) {
        for (int planeOffset = 0;
            planeOffset < image.height * image.width;
            planeOffset += image.width) {
          final pixelColor = e.bytes[planeOffset + x];
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          // Calculate pixel color
          var newVal =
              shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

          ci.data[planeOffset + x] = newVal;
        }
      }

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

      Future.delayed(Duration(milliseconds: 300)).then((value) async {
        final tempDir = (await getTemporaryDirectory()).path;

        var random = Random();
        var randomInt = random.nextInt(1000);

        File('$tempDir/TESTE1$randomInt.png').writeAsBytes(IL.encodePng(ci));
      });

      return ci;
    }).toList();

    return croppedImages;
  }

  Future<void> close() async {
    try {
      await _camera.stopImageStream();
      await _camera.dispose();
    } catch (e) {
      print(e);
    }
  }
}
