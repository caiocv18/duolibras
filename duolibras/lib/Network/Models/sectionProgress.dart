import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'dart:convert';

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
        modulesProgress: parsedJson["modulesProgress"]
            ? []
            : List<ModuleProgress>.from(parsedJson["modulesProgress"]
                .map((x) => ModuleProgress.fromMap(x, "dfasd"))),
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
}
