class Trail {
  final String title;
  final String id;

  const Trail({required this.title, required this.id});

  factory Trail.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Trail(title: parsedJson["title"], id: docId);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
