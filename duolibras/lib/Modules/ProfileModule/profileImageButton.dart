// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:duolibras/Modules/ProfileModule/takePictureScreen.dart';
import 'package:flutter/material.dart';

class ProfileImageButton extends StatefulWidget  {
  @override
  State<ProfileImageButton> createState() => _ProfileImageButtonState();
}

class _ProfileImageButtonState extends State<ProfileImageButton> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
      return Container(
        alignment: Alignment.center,
        child: (
          Stack(alignment: AlignmentDirectional.bottomCenter, fit: StackFit.loose, overflow: Overflow.visible, clipBehavior: Clip.hardEdge, children: [
            CircleAvatar(radius: 70, 
              child: imageUrl != null ? 
              Container(child: Image.file(File(imageUrl!))) : 
              Container(child: Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 70,
                semanticLabel: 'Text to announce in accessibility modes',
              ))
            )
            , Positioned(child: cameraButton(), bottom: -15) 
          ]
          )
        )
      );
  }

  Widget cameraButton() {
    return MaterialButton(
      onPressed: () {
        _openCamera();
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Icon(
        Icons.camera_alt,
        size: 12,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  void _openCamera() async {
    final frontalCamera = await _getCamera(CameraLensDirection.front);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  TakePictureScreen(camera: frontalCamera),
      )).then((value) {
        var imagePath = value as String?;
        setState(() {
          imageUrl = imagePath;
        });
      });
  }
}