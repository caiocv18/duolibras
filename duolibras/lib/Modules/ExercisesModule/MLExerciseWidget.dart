import 'package:camera/camera.dart';
import 'package:duolibras/MachineLearning/CameraWidget.dart';
import 'package:flutter/material.dart';

class MLExerciseWidget extends StatefulWidget {
  const MLExerciseWidget({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  _MLExerciseWidgetState createState() => _MLExerciseWidgetState();
}

class _MLExerciseWidgetState extends State<MLExerciseWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        backgroundColor: Colors.lightBlue,
        body: Container(child: CameraWidget(camera: widget.camera)));
  }
}
