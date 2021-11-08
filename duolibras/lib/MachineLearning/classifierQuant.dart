import 'package:download_assets/download_assets.dart';
import 'package:duolibras/MachineLearning/classification.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ClassifierQuant extends Classifier {
  ClassifierQuant(int? numThreads, String labelsPath, String modelsPath)
      : super(numThreads, labelsPath, modelsPath);

  @override
  String get modelName => '${DownloadAssetsController.assetsDir}/$modelsPath';

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 255);
}
