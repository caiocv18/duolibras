import 'package:duolibras/Services/Models/sectionProgress.dart';

class User {
  String name;
  String? email;
  final String id;
  List<SectionProgress> sectionsProgress = [];
  int currentProgress;
  String? imageUrl;
  int trailSectionIndex;

  User(
      {required this.name,
      required this.email,
      required this.id,
      required this.currentProgress,
      required this.trailSectionIndex,
      required this.imageUrl});

  factory User.fromMap(Map<String, dynamic> parsedJson, String id) {
    final user = User(
        name: parsedJson["name"],
        email: parsedJson["email"],
        currentProgress: parsedJson["currentProgress"],
        imageUrl: parsedJson["imageUrl"],
        trailSectionIndex: parsedJson["trailSectionIndex"],
        id: id);
    return user;
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
      'trailSectionIndex': trailSectionIndex,
    };
    if (imageUrl != null) map["imageUrl"] = imageUrl;
    return map;
  }
}
