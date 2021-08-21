class User {
  final String name;
  final String id;
  final List<String> trailIds;

  const User({required this.name, required this.id, required this.trailIds});

  factory User.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return User(
        name: parsedJson["name"],
        id: docId,
        trailIds: parsedJson["trailIds"].cast<String>());
  }
}
