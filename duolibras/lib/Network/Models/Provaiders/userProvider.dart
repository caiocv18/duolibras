import 'dart:developer';

import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:duolibras/Network/Service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get user {
    if (_user != null) {
      return User(
          name: _user!.name,
          email: _user!.email,
          id: _user!.id,
          currentProgress: _user!.currentProgress,
          imageUrl: _user!.imageUrl);
    }

    return User(
        name: "name",
        email: "email,",
        id: "id",
        currentProgress: 10,
        imageUrl: "imageUrl");
  }

  // UserProvider();

  void setNewUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  void setImageUrl(String url) {
    if (_user != null) {
      _user!.imageUrl = url;
      notifyListeners();
    }
  }

  void setUserName(String name) {
    if (_user != null) {
      _user!.name = name;
      print("hasListeners ${hasListeners}");
      notifyListeners();
    }
  }
}
