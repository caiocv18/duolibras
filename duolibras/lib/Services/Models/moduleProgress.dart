class ModuleProgress {
  final String id;
  final String moduleId;
  int progress;
  final int maxModuleProgress;

  bool isAvaiable = false;

  bool get isCompleted {
    return progress == maxModuleProgress;
  }

  ModuleProgress(
      {required this.id,
      required this.moduleId,
      required this.progress,
      required this.maxModuleProgress});

  factory ModuleProgress.fromMap(
      Map<String, dynamic> parsedJson, String docId) {
    return ModuleProgress(
        moduleId: parsedJson["moduleId"],
        progress: parsedJson["moduleProgress"],
        maxModuleProgress: parsedJson["maxModuleProgress"],
        id: docId);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moduleId': moduleId,
      "moduleProgress": progress,
      "maxModuleProgress": maxModuleProgress
    };
  }
}
