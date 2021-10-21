class Section {
  final String title;
  final String id;
  final String? mlModelPath;
  final String? mlLabelsPath;

  const Section({required this.title, required this.id, required this.mlModelPath, required this.mlLabelsPath});

  factory Section.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Section(
        title: parsedJson["title"], 
        id: docId, 
        mlModelPath: parsedJson["mlModelPath"],
        mlLabelsPath: parsedJson["mlLabelsPath"]
      );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
