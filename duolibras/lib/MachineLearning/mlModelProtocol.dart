import 'dart:async';
import 'package:image/image.dart' as IL;

abstract class MLModelProtocol {
  bool modelsIsLoaded = false;
  bool isOpen = false;
  Future<bool> loadModel();
  void close();
  void predict(IL.Image image);
  StreamController<PredictResult> tfLiteResultsController =
      StreamController.broadcast();
}

class PredictResult {
  final String label;
  final double accuracy;

  const PredictResult(this.label, this.accuracy);
}
