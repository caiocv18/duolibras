import 'dart:async';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as IL;

import 'Helpers/result.dart';

abstract class MLModelProtocol {
  bool modelsIsLoaded = false;
  bool isOpen = false;
  Future<void> loadModel();
  Future<void> close();
  void predict(List<IL.Image> images);
  StreamController<List<Result>> tfLiteResultsController =
      StreamController.broadcast();
}
