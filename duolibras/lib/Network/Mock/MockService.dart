import 'dart:async';
import 'dart:convert';

import 'package:duolibras/Commons/Utils/Utils.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/Trail.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Protocols/ServicesProtocol.dart';

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
  Future<List<Exercise>> getExercisesFromModuleId(
      String? sectionId, String moduleId) async {
    var completer = Completer<List<Exercise>>();

    // Nao apague -> caso precise utilizar novamente
    String jsonString = await Utils.loadJSON("Exercise");
    List<dynamic> parsedListJson = json.decode(jsonString);
    List<Exercise> exercisesList =
        List<Exercise>.from(parsedListJson.map((i) => Exercise.fromMap(i, "")));

    completer.complete(exercisesList);
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
  Future<List<ModuleProgress>> getModuleProgress() async {
    var completer = Completer<List<ModuleProgress>>();

    // Nao apague -> caso precise utilizar novamente
    String jsonString = await Utils.loadJSON("ModuleProgress");
    List<dynamic> parsedListJson = json.decode(jsonString);
    List<ModuleProgress> modulesList = List<ModuleProgress>.from(
        parsedListJson.map((i) => ModuleProgress.fromMap(i, "")));

    completer.complete(modulesList);
    return completer.future;
  }
}
