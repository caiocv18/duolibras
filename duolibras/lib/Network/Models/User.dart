import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:path/path.dart';

class User {
  final String name;
  final String email;
  final String id;
  List<ModuleProgress> modulesProgress = [];
  final int currentProgress;
  final String? imageUrl;

  User(
      {required this.name,
      required this.email,
      required this.id,
      required this.currentProgress,
      required this.imageUrl});

  factory User.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return User(
        name: parsedJson["name"],
        email: parsedJson["email"],
        currentProgress: parsedJson["currentProgress"],
        imageUrl: parsedJson["imageUrl"],
        id: docId);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'email': email,
      'currentProgress': currentProgress,
    };
    if (imageUrl != null) map["imageUrl"] = imageUrl;
    return map;
  }
}
