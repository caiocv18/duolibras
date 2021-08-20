import 'package:duolibras/Network/Models/Exercise.dart';

class Module {
  double get score =>
      exercises.map((e) => e.score).reduce((value, element) => value + element);
  final String name;
  final double progress;
  final List<Exercise> exercises;

  Module({required this.name, required this.progress, required this.exercises});

  factory Module.fromMap(Map<String, dynamic> parsedJson) {
    return Module(
        name: parsedJson["name"],
        progress: parsedJson["progress"],
        exercises: parsedJson["exercises"]);
  }
}
