import 'package:duolibras/Network/Models/ModuleProgress.dart';

class User {
  final String name;
  final String id;
  List<ModuleProgress> modulesProgress = [];
  final int currentProgress;

  User({required this.name, required this.id, required this.currentProgress});

  factory User.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return User(
        name: parsedJson["name"],
        currentProgress: parsedJson["currentProgress"],
        id: docId);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'currentProgress': currentProgress};
  }
}
