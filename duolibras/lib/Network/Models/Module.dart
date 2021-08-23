class Module {
  final String title;
  final int minProgress;
  final String id;
  final String iconUrl;

  const Module(
      {required this.title,
      required this.minProgress,
      required this.id,
      required this.iconUrl});

  factory Module.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Module(
        title: parsedJson["title"],
        minProgress: parsedJson["minProgress"],
        id: docId,
        iconUrl: parsedJson["iconUrl"]);
  }
}
