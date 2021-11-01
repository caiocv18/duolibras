import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Extensions/globalKey_extension.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/boundingBox.dart';
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
            mlModel.predict(_handleImage(image, key));
            Future.delayed(Duration(milliseconds: 500)).then((_) => isAvailable = true);
          }
        } catch (e) {
          print(e);
        }
      });
    });
  }

  List<IL.Image> _handleImage(CameraImage image, GlobalKey key) {
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


    Future.delayed(Duration(seconds: 1)).then((_) async {
        final tempDir = (await getTemporaryDirectory()).path;
        print(tempDir);
        var random = Random();
        var randomInt = random.nextInt(1000);

        final imageFile = await File('$tempDir/Teste20.$randomInt.png')
            .writeAsBytes(IL.encodePng(croppedImages.first));
    });

    

    // var croppedImage = IL.Image.fromBytes(
    //   image.width,
    //   image.height,
    //   image.planes[0].bytes,
    //   format: IL.Format.bgra,
    // );

    // croppedImage = IL.flipHorizontal(croppedImage);
    // croppedImage = IL.copyCrop(croppedImage, 240, 240, 230, 250);
    return croppedImages;
    // final path = xFile.path;
    // final bytes = await File(path).readAsBytes();
    // IL.Image? image = IL.decodeImage(bytes);
    // image = IL.flipHorizontal(image!);
    // var croppedImage = IL.copyCrop(image, 240, 240, 230, 250);

    // final tempDir = (await getTemporaryDirectory()).path;

    // var random = Random();
    // var randomInt = random.nextInt(1000);

    // final imageFile = await File('$tempDir/$randomInt.png')
    //     .writeAsBytes(IL.encodePng(croppedImage));
  }

  Future<void> close() async {
    await _camera.stopImageStream();
    await _camera.dispose();

  }

}
