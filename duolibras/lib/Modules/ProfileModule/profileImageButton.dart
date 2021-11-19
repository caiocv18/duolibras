import 'dart:io';

import 'package:camera/camera.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Modules/ProfileModule/takePictureScreen.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ProfileImageButton extends StatefulWidget {
  final bool isEnabled;
  final ProfileViewModel viewModel;
  final String? imageUrl;
  Function goLogin;

  ProfileImageButton(
      this.isEnabled, this.viewModel, this.imageUrl, this.goLogin);

  @override
  State<ProfileImageButton> createState() => _ProfileImageButtonState();
}

class _ProfileImageButtonState extends State<ProfileImageButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
          alignment: Alignment.center,
          child: (Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.bottomEnd,
              fit: StackFit.loose,
              children: [
                profileImageBoxDecoration(
                    Size(constraint.maxWidth, constraint.maxHeight)),
                Positioned(
                    child: cameraButton(context,
                        Size(constraint.maxWidth, constraint.maxHeight)),
                    bottom: -15)
              ])));
    });
  }

  Image _getProfileImage() {
    if (widget.imageUrl != null) {
      if (widget.imageUrl!.contains("firebase"))
        return Image(image: NetworkImage(widget.imageUrl!));
    }

    return Image(image: AssetImage(Constants.imageAssets.profileEmptyPhoto));
  }

  Widget profileImageBoxDecoration(Size screenSize) {
    final kGradientBoxDecoration = BoxDecoration(
      // image: DecorationImage(image: _getProfileImage(), fit: BoxFit.cover),
      shape: BoxShape.circle,
      gradient: LinearGradient(
          colors: [HexColor.fromHex("4982F6"), HexColor.fromHex("2CC4FC")]),
    );

    return Container(
      height: screenSize.width * 0.38,
      width: screenSize.width * 0.38,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: _getProfileImage().image, fit: BoxFit.cover),
                shape: BoxShape.circle)),
      ),
      decoration: kGradientBoxDecoration,
    );
  }

  Widget cameraButton(BuildContext context, Size screenSize) {
    return GestureDetector(
      child: Container(
          height: screenSize.width * 0.13,
          width: screenSize.width * 0.13,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      AssetImage(Constants.imageAssets.profileCameraButton)))),
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
        )).then((imagePath) {
      if (imagePath != null) _uploadImage(imagePath, context);
    });
  }

  void _uploadImage(String imagePath, BuildContext context) {
    var fileImage = FileImage(File(imagePath));
    widget.viewModel.uploadImage(fileImage, context);
  }
}
