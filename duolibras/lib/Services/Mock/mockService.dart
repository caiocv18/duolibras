import 'dart:async';
import 'dart:convert';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Services/Models/dynamicAsset.dart';
import 'package:duolibras/Services/Models/sectionProgress.dart';
import 'package:duolibras/Services/Models/trail.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Protocols/servicesProtocol.dart';
import 'package:flutter/material.dart';

class MockService extends ServicesProtocol {
  @override
  Future<User> getUser() async {
    var completer = Completer<User>();

    String jsonString = await Utils.loadJSON("User");
    final jsonResponse = json.decode(jsonString);
    var user = User.fromMap(jsonResponse, jsonResponse["id"]);

    completer.complete(user);
    return completer.future;
  }

  @override
  Future<User> postUser(User user, bool isNewUser) async {
    var completer = Completer<User>();

    String jsonString = await Utils.loadJSON("User");
    final jsonResponse = json.decode(jsonString);
    var user = User.fromMap(jsonResponse, jsonResponse["id"]);

    completer.complete(user);
    return completer.future;
  }

  @override
  Future<List<Exercise>> getExercisesFromModuleId(
      String? sectionId, String moduleId, int level) async {
    var completer = Completer<List<Exercise>>();

    // Nao apague -> caso precise utilizar novamente
    String jsonString = await Utils.loadJSON("Exercise");
    List<dynamic> parsedListJson = json.decode(jsonString);
    List<Exercise> exercisesList =
        List<Exercise>.from(parsedListJson.map((i) => Exercise.fromMap(i, "")));

    completer.complete(
        exercisesList.where((element) => element.level == level).toList());
    return completer.future;
  }

  @override
  Future<List<Module>> getModulesFromSectionId(String sectionId) async {
    var completer = Completer<List<Module>>();

    // Nao apague -> caso precise utilizar novamente
    String jsonString = await Utils.loadJSON("Module");
    List<dynamic> parsedListJson = json.decode(jsonString);
    List<Module> modulesList =
        List<Module>.from(parsedListJson.map((i) => Module.fromMap(i, "")));

    completer.complete(modulesList);
    return completer.future;
  }

  @override
  Future<List<Section>> getSectionsFromTrail() async {
    var completer = Completer<List<Section>>();

    // Nao apague -> caso precise utilizar novamente
    String jsonString = await Utils.loadJSON("Module");
    List<dynamic> parsedListJson = json.decode(jsonString);
    List<Section> sectionsList =
        List<Section>.from(parsedListJson.map((i) => Section.fromMap(i, "")));

    completer.complete(sectionsList);
    return completer.future;
  }

  @override
  Future<Trail> getTrail() async {
    var completer = Completer<Trail>();

    String jsonString = await Utils.loadJSON("Trail");
    final jsonResponse = json.decode(jsonString);
    completer.complete(Trail.fromMap(jsonResponse, jsonResponse["id"]));

    return completer.future;
  }

  @override
  Future<bool> postSectionProgress(SectionProgress sectionProgress) {
    var completer = Completer<bool>();
    completer.complete(true);

    return completer.future;
  }

  @override
  Future<List<User>> getUsersRanking() async {
    var completer = Completer<List<User>>();
    String jsonString = await Utils.loadJSON("UsersRanking");
    List<dynamic> parsedListJson = json.decode(jsonString);
    List<User> usersRanking = List<User>.from(
        parsedListJson.map((i) => User.fromMap(i, UniqueKey().toString())));
    completer.complete(usersRanking);
    return completer.future;
  }

  @override
  Future uploadImage(FileImage image) {
    var completer = Completer<void>();
    return completer.future;
  }

  @override
  Future<List<Exercise>> getANumberOfExercisesFromModuleId(
      String? sectionId, String moduleId, int quantity) async {
    var completer = Completer<List<Exercise>>();

    // Nao apague -> caso precise utilizar novamente
    String jsonString = await Utils.loadJSON("Exercise");
    List<dynamic> parsedListJson = json.decode(jsonString);
    List<Exercise> exercisesList =
        List<Exercise>.from(parsedListJson.map((i) => Exercise.fromMap(i, "")));
    exercisesList.shuffle();
    completer.complete(exercisesList);
    return completer.future;
  }

  @override
  Future<List<SectionProgress>> getSectionsProgress() {
    throw UnimplementedError();
  }

  @override
  Future<List<DynamicAsset>> getDynamicAssets() {
    throw UnimplementedError();
  }
}
