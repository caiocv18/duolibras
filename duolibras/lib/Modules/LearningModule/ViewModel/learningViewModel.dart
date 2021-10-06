import 'dart:async';

import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:duolibras/Network/Models/Exercise.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:duolibras/Commons/Extensions/list_extension.dart';
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
      String sectionID, String moduleID, int level) {
    return Service.instance
        .getExercisesFromModuleId(sectionID, moduleID, level);
  }

  Future<List<Exercise>> _getANumberExerciseFromModule(
      String sectionID, String moduleID, int quantity) {
    return Service.instance
        .getANumberOfExercisesFromModuleId(sectionID, moduleID, quantity)
        .then((exercises) {
      exercises.shuffle();
      List<Exercise> newExercises = [];

      for (var i = 0; i < 15; i++) {
        if (!exercises.containsAt(i)) {
          return newExercises;
        } else {
          newExercises.add(exercises[i]);
        }
      }
      return newExercises;
    });
  }

  @override
  Future<void> didSelectModule(String sectionID, Module module,
      BuildContext context, Function? handler) async {
    final level = _getUserModuleLevel(context, module);

    if (level == module.maxProgress) {
      _getANumberExerciseFromModule(sectionID, module.id, 30).then((exercises) {
        _navigateToExercisesModule(
            sectionID, module, context, exercises, handler);
      });
    } else {
      _getExerciseFromModule(sectionID, module.id, level).then((exercises) {
        _navigateToExercisesModule(
            sectionID, module, context, exercises, handler);
      });
    }
  }

  void _navigateToExercisesModule(String sectionID, Module module,
      BuildContext context, List<Exercise> exercises, Function? handler) {
    Navigator.of(context).pushNamed(ExerciseFlow.routePrefixExerciseFlow,
        arguments: {
          "exercises": exercises,
          "module": module,
          "sectionID": sectionID
        }).then((value) {
      if (handler != null) {
        handler(value);
      }
    });
  }

  int _getUserModuleLevel(BuildContext ctx, Module module) {
    final user = Provider.of<UserModel>(ctx, listen: false).user;

    try {
      final moduleProgress = user.modulesProgress
          .firstWhere((element) => element.moduleId == module.id);

      if (moduleProgress.progress == module.maxProgress) {
        return moduleProgress.progress;
      }

      return moduleProgress.progress + 1;
    } on StateError catch (_) {
      return 1;
    }
  }

  @override
  void disposeStreams() {
    _controller.close();
  }
}
