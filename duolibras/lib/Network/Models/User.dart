class User {
  final String name;
  final String id;

  const User({required this.name, required this.id});

  factory User.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return User(name: parsedJson["name"], id: docId);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
