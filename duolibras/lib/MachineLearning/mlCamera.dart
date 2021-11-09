import 'dart:async';
import 'package:camera/camera.dart';
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

      _camera.startImageStream((CameraImage image) {
        try {
          if (isAvailable) {
            isAvailable = false;
            mlModel.predict(defaultTargetPlatform == TargetPlatform.iOS
                ? _handleIOSImage(image).first
                : _handleAndroidImage(image).first);
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

    try {
      var croppedImages = image.planes.map((e) {
        var img = IL.Image.fromBytes(
          image.width,
          image.height,
          image.planes[0].bytes,
          format: IL.Format.bgra,
        );

        final int width = image.width;
        final int height = image.height;
        final int uvRowStride = image.planes[1].bytesPerRow;
        final int uvPixelStride = image.planes[1].bytesPerPixel!;
        for (int x = 0; x < width; x++) {
          // Fill image buffer with plane[0] from YUV420_888
          for (int y = 0; y < height; y++) {
            final int uvIndex =
                uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
            final int index = y * uvRowStride +
                x; // Use the row stride instead of the image width as some devices pad the image data, and in those cases the image width != bytesPerRow. Using width will give you a distored image.
            final yp = image.planes[0].bytes[index];
            final up = image.planes[1].bytes[uvIndex];
            final vp = image.planes[2].bytes[uvIndex];
            int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255).toInt();
            int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
                .round()
                .clamp(0, 255)
                .toInt();
            int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255).toInt();
            img.setPixelRgba(x, y, r, g, b);
          }
        }

        if (height < width) {
          img = IL.copyRotate(img, -90);
        }

        if (_boxDirection == HandDirection.LEFT) {
          img = IL.flipHorizontal(img);
        }

        img = IL.copyCrop(img, (0).toInt(), (img.height * 0.47).toInt(),
            (img.width * 0.45).toInt(), (img.width * 0.55).toInt());

        return img;
      }).toList();

      return croppedImages;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
      return [];
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
      await _camera.stopImageStream();
      await _camera.dispose();
    } catch (e) {
      print(e);
    }
  }
}
