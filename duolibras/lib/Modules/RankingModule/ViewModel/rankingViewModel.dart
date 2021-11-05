import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

abstract class RankingViewModelProtocol {
  Stream<List<User>>? usersRank;
  bool loading = false;
  bool firstTime = true;
  Future<void> fetchUsersRank(BuildContext context,
      {Function? exitClosure = null});
  String formatUserName(String name);

  void disposeStreams();
}

class RankingViewModel extends BaseViewModel {
  List<User> usersRank = [];
  final _errorHandler = ErrorHandler();

  RankingViewModel();

  @override
  Future<void> fetchUsersRank(BuildContext context,
      {Function? exitClosure = null}) async {
    setState(ScreenState.Loading);

    final currentUser = Provider.of<UserViewModel>(context, listen: false).user;

    return Service.instance.getUsersRanking().then((rankings) {
      if (!rankings.contains(currentUser)) {
        rankings.add(currentUser);
      }
      usersRank = rankings;
      setState(ScreenState.Normal);
    }).catchError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<void> completer = Completer<void>();

      _errorHandler.showModal(appError, context,
          tryAgainClosure: () => _errorHandler.tryAgainClosure(
              () => Service.instance.getUsersRanking(), context, completer),
          exitClosure: () {
            usersRank = [];
            setState(ScreenState.Error);
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
