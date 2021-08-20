import 'dart:async';
import 'dart:convert';

import 'package:duolibras/Commons/Utils/Utils.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Protocols/ServicesProtocol.dart';
import 'package:flutter/services.dart';

class MockService extends ServicesProtocol {
  @override
  Future<List<Exercise>> getExercises() async {
    var completer = Completer<List<Exercise>>();
    var exercises = List<Exercise>.empty();

    String jsonString = await _loadJSON("Exercises");
    List<Map> jsonResponse = tryCast(jsonString, fallback: List<Map>.empty());

    jsonResponse.forEach((element) {
      exercises.add(Exercise.fromDynamicMap(element));
    });

    completer.complete(exercises);
    return completer.future;
  }

  @override
  Future<User> getUser() async {
    var completer = Completer<User>();

    String jsonString = await _loadJSON("User");
    final jsonResponse = json.decode(jsonString);
    var user = User.fromMap(jsonResponse);

    completer.complete(user);
    return completer.future;
  }

//JSON Loader
  Future<String> _loadJSON(String path) async {
    return await rootBundle.loadString('lib/Network/Mock/Json/${path}.json');
  }
}
