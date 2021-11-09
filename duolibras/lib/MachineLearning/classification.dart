import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:duolibras/MachineLearning/mlModelProtocol.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:download_assets/download_assets.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart' as FH;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

abstract class Classifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;

  var logger = Logger();

  late List<int> _inputShape;
  late List<int> _outputShape;

  late FH.TensorImage _inputImage;
  late FH.TensorBuffer _outputBuffer;

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

  FH.NormalizeOp get preProcessNormalizeOp;
  FH.NormalizeOp get postProcessNormalizeOp;

  Classifier(int? numThreads, this.labelsPath, this.modelsPath) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final gpuDelegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
              isPrecisionLossAllowed: true,
              inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
              inferencePriority1: TfLiteGpuInferencePriority.minLatency,
              inferencePriority2: TfLiteGpuInferencePriority.minLatency,
              inferencePriority3: TfLiteGpuInferencePriority.minLatency));
      _interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegate);
    } else {
      final gpuDelegate = GpuDelegate(
        options: GpuDelegateOptions(
            allowPrecisionLoss: true, waitType: TFLGpuDelegateWaitType.active),
      );
      _interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegate);
    }

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

      _outputBuffer =
          FH.TensorBuffer.createFixedSize(_outputShape, _outputType);
      _probabilityProcessor =
          FH.TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  Future<void> loadLabels() async {
    File labelsFile = File(_labelsFileName);

    labels = await FH.FileUtil.loadLabelsFromFile(labelsFile);
    if (labels.length > 0) {
      print("Load labels sucessfully");
    } else {
      print('Unable to load labels');
    }
  }

  FH.TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);
    return FH.ImageProcessorBuilder()
        .add(FH.ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(FH.ResizeOp(
            _inputShape[1], _inputShape[2], FH.ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  FH.Category predict(Image image) {
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = FH.TensorImage(_inputType);
    _inputImage.loadImage(image);
    _inputImage = _preProcess();
    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    print('Time to load image: $pre ms');

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference $run ms');

    Map<String, double> labeledProb = FH.TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();
    final pred = getTopProbability(labeledProb);

    return FH.Category(pred.key, pred.value);
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
