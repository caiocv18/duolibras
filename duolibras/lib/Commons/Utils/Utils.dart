import 'package:duolibras/Services/Models/appError.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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

  static AppError logAppError(Object? error){
    final AppError appError = Utils.tryCast(error, fallback: AppError(AppErrorType.Unknown, "Erro desconhecido"));
    debugPrint("Error: ${appError.description}");
    return appError;
  }
  
}
