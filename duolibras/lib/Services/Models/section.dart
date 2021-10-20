class Section {
  final String title;
  final String id;
  final String? mlModelName;
  final String? mlLabelsName;

  const Section({required this.title, required this.id, required this.mlModelName, required this.mlLabelsName});

  factory Section.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Section(
        title: parsedJson["title"], 
        id: docId, 
        mlModelName: parsedJson["mlModelName"],
        mlLabelsName: parsedJson["mlLabelsName"]
      );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
