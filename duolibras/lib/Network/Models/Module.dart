class Module {
  final String name;
  final int minProgress;
  final List<String> exercises;
  final String id;
  final String iconUrl;

  const Module(
      {required this.name,
      required this.minProgress,
      required this.exercises,
      required this.id,
      required this.iconUrl});

  factory Module.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Module(
        name: parsedJson["name"],
        minProgress: parsedJson["minProgress"],
        exercises: parsedJson["exercises"].cast<String>(),
        id: docId,
        iconUrl: parsedJson["iconUrl"]);
  }
}
