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
  Function goLogin;

  ProfileImageButton(this.isEnabled, this.viewModel, this.imageUrl, this.goLogin);

  @override
  State<ProfileImageButton> createState() => _ProfileImageButtonState();
}

class _ProfileImageButtonState extends State<ProfileImageButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: (
          Stack(
            clipBehavior: Clip.none, 
            alignment: AlignmentDirectional.bottomEnd,
            fit: StackFit.loose,
            children: [
                Container(
                  height: 145,
                  width: 145,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:  DecorationImage(
                                fit: BoxFit.cover,
                                image: _getProfileImage()
                      ),
                      border: Border.all(width: 4, color: HexColor.fromHex("4982F6"))
                  )
                ),
                Positioned(child: cameraButton(context), bottom: -15)
            ])));
  }

  ImageProvider _getProfileImage() {
    if (widget.imageUrl != null) {
      return NetworkImage(widget.imageUrl!);
    } else {
      return AssetImage(Constants.imageAssets.profileEmptyPhoto);
    }
  }

  Widget cameraButton(BuildContext context) {
    return GestureDetector(
      child: 
      Container(
        height: 51,
        width: 51,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:  DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(Constants.imageAssets.profileCameraButton)
              )
          )
        ),
      onTap: () => widget.isEnabled ? _openCamera(context) : widget.goLogin(),
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
