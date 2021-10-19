import 'dart:convert';

import 'moduleProgress.dart';

class SectionProgress {
  final String id;
  final String sectionId;
  int progress;
  List<ModuleProgress> modulesProgress;

  bool get isCompleted {
    for (var m in modulesProgress) {
      if (!m.isCompleted) {
        return false;
      }
    }
    return true;
  }

  SectionProgress(
      {required this.id,
      required this.sectionId,
      required this.progress,
      required this.modulesProgress});

  factory SectionProgress.fromMap(
      Map<String, dynamic> parsedJson, String docId) {
    return SectionProgress(
        sectionId: parsedJson["sectionId"],
        progress: parsedJson["progress"],
        modulesProgress: _modulesProgressFrom(parsedJson["modulesProgress"]),
        id: docId);
  }

  static List<ModuleProgress> _modulesProgressFrom(List<dynamic> result) {
    List<ModuleProgress> modules =
        result.map((f) => ModuleProgress.fromMap(f, f["id"])).toList();

    return modules;
  }

  factory SectionProgress.fromMapLocal(Map<String, dynamic> sectionJson,
      List<Map<String, dynamic>> modulesJson, String docId) {
    return SectionProgress(
        sectionId: sectionJson["sectionId"],
        progress: sectionJson["progress"],
        modulesProgress: _modulesProgressFrom(modulesJson),
        id: docId);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sectionId': sectionId,
      "progress": progress,
      "modulesProgress":
          List<dynamic>.from(modulesProgress.map((x) => x.toMap()))
    };
  }

  Map<String, dynamic> toMapLocal() {
    return {'id': id, 'sectionId': sectionId, "progress": progress};
  }

  List<Map<String, dynamic>> modulesProgressToMap() {
    return List<Map<String, dynamic>>.from(modulesProgress.map((modProgress) {
      return {
        "id": modProgress.id,
        "moduleId": modProgress.moduleId,
        "moduleProgress": modProgress.progress,
        "sectionId": this.sectionId,
        "maxModuleProgress": modProgress.maxModuleProgress
      };
    }));
  }
}
