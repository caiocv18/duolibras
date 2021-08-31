import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class MlModel {
  MlModel() {
    loadModel();
  }

  void loadModel() async {
    await Tflite.loadModel(
        model: "lib/Assets/Files/converted_model.tflite",
        labels: "lib/Assets/Files/labels.csv");
  }

  static void runModel(CameraImage image) async {
    await Tflite.runModelOnFrame(
            bytesList: image.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            numResults: 5)
        .then((value) {
      if (value != null) {
        print(value);
      }
    });
  }
}
