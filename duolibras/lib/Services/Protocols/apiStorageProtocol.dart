import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duolibras/Services/Models/dynamicAsset.dart';
import 'package:flutter/cupertino.dart';

abstract class APIStorageProtocol {
  Future<String> uploadImage(FileImage image);
  Future<List<DynamicAsset>> getDynamicAssets();
}