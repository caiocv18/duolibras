import 'package:flutter/material.dart';
import 'Widgets/Components/cameraWidget.dart';

class MLExerciseWidget extends StatefulWidget {
  const MLExerciseWidget({Key? key}) : super(key: key);

  @override
  _MLExerciseWidgetState createState() => _MLExerciseWidgetState();
}

class _MLExerciseWidgetState extends State<MLExerciseWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ML Exercise")),
      backgroundColor: Colors.lightBlue,
      // body: Container(child: CameraWidget())
    );
  }
}
