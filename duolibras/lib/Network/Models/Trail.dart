import 'package:duolibras/Network/Models/Module.dart';
import 'package:uuid/uuid.dart';

class Trail {
  double get score =>
      modules.map((e) => e.score).reduce((value, element) => value + element);
  final String name;
  final double progress;
  final List<Module> modules;
  final Uuid userId;

  Trail(
      {required this.name,
      required this.progress,
      required this.modules,
      required this.userId});

  factory Trail.fromMap(Map<String, dynamic> parsedJson) {
    return Trail(
        name: parsedJson["name"],
        progress: parsedJson["progress"],
        modules: parsedJson["modules"],
        userId: parsedJson["userId"]);
  }
}
