// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:duolibras/Modules/ProfileModule/profileViewModel.dart';
import 'package:duolibras/Modules/ProfileModule/takePictureScreen.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImageButton extends StatefulWidget {
  final bool isEnabled;
  final ProfileViewModel viewModel;

  ProfileImageButton(this.isEnabled, this.viewModel);

  @override
  State<ProfileImageButton> createState() => _ProfileImageButtonState();
}

class _ProfileImageButtonState extends State<ProfileImageButton> {
  var imageUrl = UserSession.instance.userProvider.user.imageUrl;

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
                      ?
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 100,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       fit: BoxFit.fill,
                      //       image: FileImage(File(imageUrl!)),
                      //     ),
                      //   ),
                      // )

                      Container(
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
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.setImageUrl(
        "https://firebasestorage.googleapis.com/v0/b/libras-tcc.appspot.com/o/ImagensTeste%2FIMG_5464.JPG?alt=media&token=ec254d7e-45a9-4e28-b09d-838481304d89");
    // final frontalCamera = await _getCamera(CameraLensDirection.front);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => TakePictureScreen(camera: frontalCamera),
    //     )).then((value) {
    //   var imagePath = value as String?;
    //   setState(() {
    //     imageUrl = imagePath;
    //     _uploadImage();
    //   });
    // });
  }

  void _uploadImage() {
    var fileImage = FileImage(File(imageUrl!));
    widget.viewModel.uploadImage(fileImage);
  }
}
