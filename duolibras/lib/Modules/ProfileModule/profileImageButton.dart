import 'dart:io';

import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Modules/ProfileModule/takePictureScreen.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:flutter/material.dart';

class ProfileImageButton extends StatefulWidget {
  final bool isEnabled;
  final ProfileViewModel viewModel;

  ProfileImageButton(this.isEnabled, this.viewModel);

  @override
  State<ProfileImageButton> createState() => _ProfileImageButtonState();
}

class _ProfileImageButtonState extends State<ProfileImageButton> {
  var imageUrl = locator<UserModel>().user.imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: (Stack(
            alignment: AlignmentDirectional.bottomCenter,
            fit: StackFit.loose,
            overflow: Overflow.visible,
            clipBehavior: Clip.hardEdge,
            children: [
              CircleAvatar(
                  radius: 70,
                  child: imageUrl != null
                      ? Container(
                          width: 190.0,
                          height: 190.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(imageUrl!)))))
                      : Container(
                          child: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                          size: 70,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ))),
              Positioned(child: cameraButton(), bottom: -15)
            ])));
  }

  Widget cameraButton() {
    return MaterialButton(
      onPressed: () => widget.isEnabled ? _openCamera() : null,
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
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: frontalCamera),
        )).then((value) {
      var imagePath = value as String?;
      setState(() {
        imageUrl = imagePath;
        _uploadImage();
      });
    });
  }

  void _uploadImage() {
    var fileImage = FileImage(File(imageUrl!));
    widget.viewModel.uploadImage(fileImage);
  }
}
