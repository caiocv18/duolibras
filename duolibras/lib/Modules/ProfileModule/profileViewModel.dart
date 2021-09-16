import 'package:duolibras/Network/Authentication/Firebase/FirebaseAuthenticator.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';

class ProfileViewModel {
  final _authenticator = FirebaseAuthenticator();
  final _service = Service.instance;

  Future<User> updateUser(User user) {
    return _service.postUser(user);
  }

  Future<void> signOut() {
    return _authenticator.signOut();
  }

  Future uploadImage(FileImage image) {
    return _service.uploadImage(image);
  }
}