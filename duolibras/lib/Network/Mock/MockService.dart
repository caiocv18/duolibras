import 'dart:async';
import 'dart:convert';

import 'package:duolibras/Commons/Utils/Utils.dart';
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
  Future<Exercise> getExerciseFromId(String exerciseId) async {
    var completer = Completer<Exercise>();

    // Nao apague -> caso precise utilizar novamente
    // List<dynamic> parsedListJson = json.decode(jsonString);
    // List<Exercise> exercisesList =
    //     List<Exercise>.from(parsedListJson.map((i) => Exercise.fromMap(i)));

    String jsonString = await Utils.loadJSON("Exercise");
    final jsonResponse = json.decode(jsonString);

    completer.complete(Exercise.fromMap(jsonResponse, jsonResponse["id"]));
    return completer.future;
  }

  @override
  Future<Module> getModuleFromId(String moduleId) async {
    var completer = Completer<Module>();

    String jsonString = await Utils.loadJSON("Module");
    final jsonResponse = json.decode(jsonString);

    completer.complete(Module.fromMap(jsonResponse, jsonResponse["id"]));

    return completer.future;
  }

  @override
  Future<Section> getSectionFromId(String sectionId) async {
    var completer = Completer<Section>();

    String jsonString = await Utils.loadJSON("Section");
    final jsonResponse = json.decode(jsonString);
    completer.complete(Section.fromMap(jsonResponse, jsonResponse["id"]));

    return completer.future;
  }

  @override
  Future<Trail> getTrailFromId(String trailId) async {
    var completer = Completer<Trail>();

    String jsonString = await Utils.loadJSON("Trail");
    final jsonResponse = json.decode(jsonString);
    completer.complete(Trail.fromMap(jsonResponse, jsonResponse["id"]));

    return completer.future;
  }
}
