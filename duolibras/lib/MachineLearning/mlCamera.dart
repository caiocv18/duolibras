import 'dart:async';

import 'package:camera/camera.dart';
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
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420);

    return await _camera.initialize().then((value) {
      AppHelper.log("_initializeCamera", "Camera initialized, starting camera stream..");
      mlModel.loadModel();

      _camera.startImageStream((CameraImage image) {
        try {
          if (isAvailable) {
            isAvailable = false;
            mlModel.predict(defaultTargetPlatform == TargetPlatform.iOS ? _handleIOSImage(image, key) : _handleAndroidImage(image));
            Future.delayed(Duration(milliseconds: 500)).then((_) => isAvailable = true);
          }
        } catch (e) {
          print(e);
        }
      });
    });
  }

  static List<IL.Image> _handleAndroidImage(CameraImage image) {
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

      ci = IL.copyCrop(ci, 
      (image.width * 0.53).toInt(), 
      (image.height * 0.47).toInt(), 
      (image.width * 0.5).toInt(), 
      (image.width * 0.6).toInt());

      return ci;
    }).toList();

    return croppedImages;
  }

  List<IL.Image> _handleIOSImage(CameraImage image, GlobalKey key) {
    var croppedImages = image.planes.map((e) {
      var ci = IL.Image.fromBytes(
          image.width,
          image.height,
          image.planes[0].bytes, 
          format: IL.Format.bgra,
      );
  
      // final size = MediaQuery.of(context).size;
      // ci = IL.flipHorizontal(ci);
      ci = IL.copyCrop(ci, 
      (image.width * 0.53).toInt(), 
      (image.height * 0.47).toInt(), 
      (image.width * 0.5).toInt(), 
      (image.width * 0.6).toInt());

      return ci;
     }
    ).toList();

    return croppedImages;
  }

  Future<void> close() async {
    await _camera.stopImageStream();
    await _camera.dispose();
  }

}
