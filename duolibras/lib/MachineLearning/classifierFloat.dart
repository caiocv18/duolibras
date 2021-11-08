import 'package:download_assets/download_assets.dart';
import 'package:duolibras/MachineLearning/classification.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ClassifierFloat extends Classifier {
  ClassifierFloat(int? numThreads, String labelsPath, String modelsPath)
      : super(numThreads, labelsPath, modelsPath);

  @override
  String get modelName => '${DownloadAssetsController.assetsDir}/$modelsPath';

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(127.5, 127.5);

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);
}
