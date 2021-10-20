import 'dart:async';
import 'package:download_assets/download_assets.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Services/Firebase/firebaseErrors.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:duolibras/Services/Models/dynamicAsset.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';

class LaunchViewModel {
  final _errorHandler = ErrorHandler();

  LaunchViewModel() {
    DownloadAssetsController.init();
  }

  Future getInitialData(BuildContext context) {
    Completer completer = Completer();

    Service.instance.getUser().then((user) {
      locator<UserModel>().setNewUser(user);
      Service.instance.getDynamicAssets().then((assets) {
        final mlModel = assets.firstWhere((element) => element.assetType == AssetTypes.mlModel);
        _downloadMlModelAsset(context, mlModel).then((value) => completer.complete());
      });
    }).catchError((error, stackTrace) {
      final appError = Utils.logAppError(error);

      final FirebaseErrors firebaseError = Utils.tryCast(error, fallback: FirebaseErrors.Unknown);
      if (firebaseError == FirebaseErrors.GetUserError){
          _errorHandler.showModal(appError, context, 
        tryAgainClosure: () => _errorHandler.tryAgainClosure(() => Service.instance.getUser(), context, completer),
        exitClosure: () => completer.complete());
      }
      else {
          _errorHandler.showModal(appError, context, 
        tryAgainClosure: () => _errorHandler.tryAgainClosure(() => Service.instance.getDynamicAssets(), context, completer),
        exitClosure: () => completer.complete());
      }
    });

    return completer.future;
  }

  Future _downloadMlModelAsset(BuildContext context, DynamicAsset mlAsset) async {
    Completer<void> completer = Completer();
    bool assetsDownloaded = await DownloadAssetsController.assetsDirAlreadyExists();

    if (assetsDownloaded) {
      completer.complete();
      return;
    }

    try {
      await DownloadAssetsController.startDownload(
          assetsUrl: mlAsset.path,
          onProgress: (progressValue) {
            print(progressValue);
          },
          onComplete: () {
            completer.complete();
            return;
          },
          onError: (exception) {
            _errorHandler.showModal(AppError(AppErrorType.FileServiceError, "Ops, erro ao baixar arquivos necessários"), 
                context,
                enableDrag: false,
                tryAgainClosure: () => _errorHandler.tryAgainClosure(() => _downloadMlModelAsset(context, mlAsset),context,completer)
            );
          }
      );
    } on DownloadAssetsException {
      _errorHandler.showModal(AppError(AppErrorType.FileServiceError, "Ops, erro ao baixar arquivos necessários"), 
                context,
                enableDrag: false,
                tryAgainClosure: () => _errorHandler.tryAgainClosure(() => _downloadMlModelAsset(context, mlAsset),context,completer)
            );
    }

    return completer.future;
  }


}