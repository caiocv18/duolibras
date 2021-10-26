import 'dart:io';

import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Modules/ProfileModule/takePictureScreen.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ProfileImageButton extends StatefulWidget {
  final bool isEnabled;
  final ProfileViewModel viewModel;
  final String? imageUrl;

  ProfileImageButton(this.isEnabled, this.viewModel, this.imageUrl);

  @override
  State<ProfileImageButton> createState() => _ProfileImageButtonState();
}

class _ProfileImageButtonState extends State<ProfileImageButton> {
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
                  backgroundColor: HexColor.fromHex("4982F6"),
                  radius: 70,
                  child: widget.imageUrl != null
                      ? CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 234, 234, 1),
                          radius: 66,
                          child: Container(
                              width: 190.0,
                              height: 190.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget.imageUrl!)))),
                        )
                      : CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 234, 234, 1),
                          radius: 66,
                          child: Container(
                              child: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 67,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          )),
                        )),
              Positioned(child: cameraButton(context), bottom: -15)
            ])));
  }

  Widget cameraButton(BuildContext context) {
    return MaterialButton(
      onPressed: () => widget.isEnabled ? _openCamera(context) : null,
      color: Colors.blue,
      textColor: Colors.white,
      child: Image.asset(
        Constants.imageAssets.camera_button,
        height: 20,
        width: 20,
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

  void _openCamera(BuildContext context) async {
    final frontalCamera = await _getCamera(CameraLensDirection.front);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: frontalCamera),
        )
    ).then((imagePath) {
      _uploadImage(imagePath, context);
    });
  }

  void _uploadImage(String imagePath, BuildContext context) {
    var fileImage = FileImage(File(imagePath));
    widget.viewModel.uploadImage(fileImage, context);
  }
}
