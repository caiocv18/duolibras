import 'package:audioplayers/audioplayers.dart';
import 'package:duolibras/Commons/Utils/Constants.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum FeedbackTypes { success, error }

class Utils {
  //Cast
  static T tryCast<T>(dynamic x, {required T fallback}) {
    try {
      return (x as T);
    } on TypeError catch (e) {
      print('CastError when trying to cast $x to $T!');
      print(e);
      return fallback;
    }
  }

  //JSON Loader
  static Future<String> loadJSON(String path) async {
    return await rootBundle.loadString('lib/Network/Mock/Json/${path}.json');
  }

  static AppError logAppError(Object? error) {
    final AppError appError = Utils.tryCast(error,
        fallback: AppError(AppErrorType.Unknown, "Erro desconhecido"));
    debugPrint("Error: ${appError.description}");
    return appError;
  }

  static showFeedback(FeedbackTypes type) {
    switch (type) {
      case FeedbackTypes.success:
        HapticFeedback.heavyImpact();
        _playLocalAsset(Constants.soundAssets.successSound);
        break;
      case FeedbackTypes.error:
        HapticFeedback.vibrate();
        _playLocalAsset(Constants.soundAssets.errorSound);
        break;
    }
  }

  static Future<AudioPlayer> _playLocalAsset(String name) async {
    AudioCache cache = new AudioCache();
    return await cache.play(name);
  }
}
