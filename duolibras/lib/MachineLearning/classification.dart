import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:duolibras/MachineLearning/mlModelProtocol.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:download_assets/download_assets.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

abstract class Classifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;

  var logger = Logger();

  late List<int> _inputShape;
  late List<int> _outputShape;

  late TensorImage _inputImage;
  late TensorBuffer _outputBuffer;

  late TfLiteType _inputType;
  late TfLiteType _outputType;

  final String labelsPath;
  final String modelsPath;

  late String _labelsFileName =
      '${DownloadAssetsController.assetsDir}/$labelsPath';

  // final int _labelsLenght = 1001;

  late var _probabilityProcessor;

  late List<String> labels;

  String get modelName;

  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;

  Classifier(int? numThreads, this.labelsPath, this.modelsPath) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

    loadModel();
    loadLabels();
  }

  Future<void> loadModel() async {
    File modelFile = File(modelName);

    try {
      interpreter =
          Interpreter.fromFile(modelFile, options: _interpreterOptions);

      _inputShape = interpreter.getInputTensor(0).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      _inputType = interpreter.getInputTensor(0).type;
      _outputType = interpreter.getOutputTensor(0).type;

      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  Future<void> loadLabels() async {
    File labelsFile = File(_labelsFileName);

    labels = await FileUtil.loadLabelsFromFile(labelsFile);
    if (labels.length > 0) {
      print("Load labels sucessfully");
    } else {
      print('Unable to load labels');
    }
  }

  TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  Category predict(Image image) {
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = TensorImage(_inputType);
    _inputImage.loadImage(image);
    _inputImage = _preProcess();

    var buffer = _inputImage.getBuffer();

    var newImage = Image.fromBytes(
        _inputImage.width, _inputImage.height, buffer.asUint8List());

    Future.delayed(Duration(milliseconds: 1000)).then((value) async {
      final tempDir = (await getTemporaryDirectory()).path;

      var random = Random();
      var randomInt = random.nextInt(1000);

      File('$tempDir/TESTE-RANGELNUB$randomInt.png')
          .writeAsBytes(encodePng(newImage));
    });

    final pre = DateTime.now().microsecondsSinceEpoch - pres;

    print('Time to load image: $pre ms');

    final runs = DateTime.now().microsecondsSinceEpoch;
    interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference $run ms');

    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();
    final pred = getTopProbability(labeledProb);

    return Category(pred.key, pred.value);
  }

  void close() {
    interpreter.close();
  }
}

MapEntry<String, double> getTopProbability(Map<String, double> labeledProd) {
  var pq = PriorityQueue<MapEntry<String, double>>(compare);
  pq.addAll(labeledProd.entries);

  return pq.first;
}

int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
  if (e1.value > e2.value) {
    return -1;
  } else if (e1.value == e2.value) {
    return 0;
  } else {
    return 1;
  }
}
