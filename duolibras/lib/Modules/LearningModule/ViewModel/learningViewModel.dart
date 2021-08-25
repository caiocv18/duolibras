import 'dart:async';

import 'package:duolibras/Modules/LearningModule/Widgets/learningWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Service.dart';

class LearningViewModel with SectionsViewModel, LearningViewModelProtocol {
  @override
  Future<List<Module>> getModulesfromSection(String sectionID) async {
    return Service.instance.getModulesFromSectionId(sectionID);
  }

  @override
  Future<List<Section>> getSectionsFromTrail(String id) {
    return Service.instance.getSectionsFromTrail();
  }

  List<String> allSectionsID = [];
  StreamController<List<Section>> _controller =
      StreamController<List<Section>>();

  List<Section> allSections = [];
  LearningViewModel() {
    sections = _controller.stream;
  }

  @override
  Future<void> fetchSections() async {
    loading = false;
    await Service.instance.getSectionsFromTrail().then((newSections) {
      hasMore = false;
      loading = false;
      _controller.sink.add(newSections);
    }).onError((error, stackTrace) {
      error = true;
      hasMore = false;
      _controller.sink.add([]);
    });
  }
}
