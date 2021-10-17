import 'dart:async';

import 'package:camera/camera.dart';

import 'result.dart';

abstract class MLModelProtocol {
  bool modelsIsLoaded = false;
  bool isOpen = false;
  Future<void> loadModel();
  Future<void> close();
  void predict(CameraImage image);
  StreamController<List<Result>> tfLiteResultsController = StreamController.broadcast();
}
