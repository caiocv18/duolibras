class Section {
  final String title;
  final String id;

  const Section({required this.title, required this.id});

  factory Section.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Section(title: parsedJson["title"], id: docId);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
