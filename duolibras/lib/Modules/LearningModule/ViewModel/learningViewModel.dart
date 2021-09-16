import 'dart:async';

import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../mainRouter.dart';

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
  BehaviorSubject<List<Section>> _controller = BehaviorSubject<List<Section>>();

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
  Future<void> didSelectModule(String sectionID, String moduleID,
      BuildContext context, Function? handler) async {
    _getExerciseFromModule(sectionID, moduleID).then((excersies) {
      // final viewModel = ExerciseViewModel(excersies);
      // final routeName = excersies.first.category == ExercisesCategory.writing
      // ? ExerciseWritingScreen.routeName
      // : ExerciseMultiChoiceScreen.routeName;

      Navigator.of(context).pushNamed(ExerciseFlow.routePrefixExerciseFlow,
          arguments: {
            "exercises": excersies,
            "moduleID": moduleID
          }).then((value) {
        if (handler != null) {
          handler(value);
        }
      });
    });
  }

  @override
  void disposeStreams() {
    _controller.close();
  }
}
