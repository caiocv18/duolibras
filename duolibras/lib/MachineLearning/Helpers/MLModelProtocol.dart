import 'package:camera/camera.dart';

abstract class MLModelProtocol {
  bool modelsIsLoaded = false;
  bool isOpen = false;
  Future<void> loadModel();
  void close();
  void predict(CameraImage image);
}
