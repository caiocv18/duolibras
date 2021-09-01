import 'dart:async';

import 'package:duolibras/Modules/ExercisesModule/ViewModel/exerciseViewModel.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseMultiChoiceScreen.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseWritingScreen.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/ExercisesCategory.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class LearningViewModel
    with SectionsViewModel, ModuleViewModel, LearningViewModelProtocol {
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

  Future<List<Exercise>> _getExerciseFromModule(
      String sectionID, String moduleID) {
    return Service.instance.getExercisesFromModuleId(sectionID, moduleID);
  }

  @override
  Future<void> didSelectModule(
      String sectionID, String moduleID, BuildContext context) async {
    _getExerciseFromModule(sectionID, moduleID).then((excersies) {
      // final viewModel = ExerciseViewModel(excersies);
      // final routeName = excersies.first.category == ExercisesCategory.writing
      // ? ExerciseWritingScreen.routeName
      // : ExerciseMultiChoiceScreen.routeName;

      Navigator.of(context).pushNamed(ExerciseFlow.routeStartExerciseFlow,
          arguments: {"exercises": excersies, "moduleID": moduleID});
    });
  }
}
