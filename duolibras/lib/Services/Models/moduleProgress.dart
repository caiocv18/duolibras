class ModuleProgress {
  final String id;
  final String moduleId;
  final int progress;

  const ModuleProgress(
      {required this.id, required this.moduleId, required this.progress});

  factory ModuleProgress.fromMap(
      Map<String, dynamic> parsedJson, String docId) {
    return ModuleProgress(
        moduleId: parsedJson["moduleId"],
        progress: parsedJson["moduleProgress"],
        id: docId);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'moduleId': moduleId, "moduleProgress": progress};
  }
}
