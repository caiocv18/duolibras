import 'package:uuid/uuid.dart';

class User {
  final String name;
  final Uuid id;

  const User({required this.name, required this.id});

  factory User.fromMap(Map<String, dynamic> parsedJson) {
    return User(name: parsedJson["name"], id: parsedJson["id"]);
  }
}
