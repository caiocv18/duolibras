import 'package:duolibras/Services/Models/sectionProgress.dart';

class User {
  String name;
  String? email;
  final String id;
  List<SectionProgress> sectionsProgress = [];
  int currentProgress;
  String? imageUrl;

  User(
      {required this.name,
      required this.email,
      required this.id,
      required this.currentProgress,
      required this.imageUrl});

  factory User.fromMap(Map<String, dynamic> parsedJson, String id) {
    return User(
        name: parsedJson["name"],
        email: parsedJson["email"],
        currentProgress: parsedJson["currentProgress"],
        imageUrl: parsedJson["imageUrl"],
        id: id);
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

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
