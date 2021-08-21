class Trail {
  final String title;
  final List<String> sections;
  final String id;

  const Trail({required this.title, required this.sections, required this.id});

  factory Trail.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Trail(
        title: parsedJson["title"],
        sections: parsedJson["sections"].cast<String>(),
        id: docId);
  }
}
