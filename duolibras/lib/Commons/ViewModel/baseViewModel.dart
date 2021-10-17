import 'package:flutter/material.dart';

import 'screenState.dart';

class BaseViewModel extends ChangeNotifier {
  ScreenState _state = ScreenState.Normal;

  ScreenState get state => _state;

  void setState(ScreenState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
