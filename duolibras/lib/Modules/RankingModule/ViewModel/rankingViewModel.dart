import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';

abstract class RankingViewModelProtocol {
  Stream<List<User>>? usersRank;
  bool loading = false;
  bool firstTime = true;
  Future<void> fetchUsersRank(BuildContext context, {Function? exitClosure = null});
  String formatUserName(String name);

  void disposeStreams();
}

class RankingViewModel extends RankingViewModelProtocol {
  final _errorHandler = ErrorHandler();
  BehaviorSubject<List<User>> _controller = BehaviorSubject<List<User>>();

  RankingViewModel() {
    usersRank = _controller.stream;
  }

  @override
  void disposeStreams() {
    _controller.close();
  }

  @override
  Future<void> fetchUsersRank(BuildContext context, {Function? exitClosure = null}) async {
    loading = true;

    return Service.instance.getUsersRanking().then((rankings) {
      loading = false;
      firstTime = false;
      _controller.sink.add(rankings);
    })
    .catchError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<void> completer = Completer<void>();

      _errorHandler.showModal(appError, context, 
        tryAgainClosure: () => _errorHandler.tryAgainClosure(() => Service.instance.getUsersRanking(), context, completer), 
        exitClosure: () {
          loading = false;
          firstTime = false;
          _controller.sink.add([]);
          completer.complete();
        });

      return completer.future;
    });
  }

  @override
  String formatUserName(String name) {
    final arr = name.split("@");
    return arr[0];
  }
}
