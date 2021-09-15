import 'package:flutter/cupertino.dart';

abstract class APIStorageProtocol {
  Future uploadImage(FileImage image);
}