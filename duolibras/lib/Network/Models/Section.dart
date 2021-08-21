class Section {
  final String title;
  final List<String> modules;
  final String id;

  const Section({required this.title, required this.modules, required this.id});

  factory Section.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Section(
        title: parsedJson["title"],
        modules: parsedJson["modules"].cast<String>(),
        id: docId);
  }
}
