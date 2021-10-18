import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/sectionPage.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:duolibras/Services/Models/sectionProgress.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:duolibras/Commons/Extensions/list_extension.dart';

class LearningViewModel with ModuleViewModel, LearningViewModelProtocol {
  final _errorHandler = ErrorHandler();
  List<String> allSectionsID = [];
  BehaviorSubject<List<Section>> _controller = BehaviorSubject<List<Section>>();

  List<Section> allSections = [];

  Map<Color, int> colorForModules = {};
  LearningViewModel() {
    sections = _controller.stream;
    pages = _controllerModules.stream;
  }

  BehaviorSubject<WrapperSectionPage> _controllerModules = BehaviorSubject<WrapperSectionPage>();
  WrapperSectionPage _wrapperSectionPage = WrapperSectionPage([]);

  Future<void> _getModules(List<Section> newSections, BuildContext context) async {
    final sectionsProgress = Provider.of<UserModel>(context, listen: false).user.sectionsProgress;

    for (var i = 0; i < newSections.length; i++) {
      await getModulesfromSection(newSections[i].id, context).then((modules) {
        _wrapperSectionPage.pages.add(SectionPage(newSections[i], modules));
        Color color = modules.first.color;
        colorForModules.addAll({color: modules.length});
      });
    }

    if (sectionsProgress.length != newSections.length) {
      _wrapperSectionPage.pages.forEach((page) {
        var contains = false;
        sectionsProgress.forEach((progress) {
          if (progress.sectionId == page.section.id) {
            contains = true;
          }
        });

        if (!contains) {
          sectionsProgress.add(SectionProgress(
              id: UniqueKey().toString(),
              sectionId: page.section.id,
              progress: 0,
              modulesProgress: page.modules
                  .map((m) => ModuleProgress(
                      id: UniqueKey().toString(),
                      moduleId: m.id,
                      progress: 0,
                      maxModuleProgress: m.maxProgress))
                  .toList()));
        }
      });
    }

    _controllerModules.sink.add(_wrapperSectionPage);
  }

  Future<List<Module>> getModulesfromSection(String sectionID, BuildContext context) async {
    return Service.instance
        .getModulesFromSectionId(sectionID)
        .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Module>> completer = Completer<List<Module>>();

      _errorHandler.showModal(appError, context, enableDrag: false,
      tryAgainClosure: () => _errorHandler.tryAgainClosure(() => 
      Service.instance.getModulesFromSectionId(sectionID), context, completer));
      return completer.future;
    });
  }

  Future<List<Section>> getSectionsFromTrail(BuildContext context) {
    return Service.instance.getSectionsFromTrail()
    .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Section>> completer = Completer<List<Section>>();

      _errorHandler.showModal(appError, context, enableDrag: false,
      tryAgainClosure: () => _errorHandler.tryAgainClosure(() => 
      Service.instance.getSectionsFromTrail(), context, completer)
      );
      return completer.future;
    });
  }

  @override
  Future<void> fetchSections(BuildContext context) async {
    loading = false;
    await getSectionsFromTrail(context).then((newSections) {
      hasMore = false;
      loading = false;
      _getModules(newSections, context);
      // _controller.sink.add(newSections);
    });
  }

  Future<List<Exercise>> _getExerciseFromModule(String sectionID, String moduleID, int level, BuildContext context) {
    return Service.instance.getExercisesFromModuleId(sectionID, moduleID, level)
    .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Exercise>> completer = Completer<List<Exercise>>();

      _errorHandler.showModal(appError, context, 
      tryAgainClosure: () =>  _errorHandler.tryAgainClosure(() => 
      Service.instance.getExercisesFromModuleId(sectionID, moduleID, level), context, completer),
      exitClosure: () => completer.complete([]));
      return completer.future;
    });
  }

  Future<List<Exercise>> _getANumberExerciseFromModule(
      String sectionID, String moduleID, int quantity, BuildContext context) {
    return Service.instance
        .getANumberOfExercisesFromModuleId(sectionID, moduleID, quantity)
        .onError((error, stackTrace) {
          final appError = Utils.logAppError(error);
          Completer<List<Exercise>> completer = Completer<List<Exercise>>();

          _errorHandler.showModal(appError, context, 
          tryAgainClosure: () => _errorHandler.tryAgainClosure(() => 
          Service.instance.getANumberOfExercisesFromModuleId(sectionID, moduleID, quantity), context, completer),
          exitClosure: () => completer.complete([]));
          return completer.future;
      })
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
    final level = _getUserModuleLevel(context, sectionID, module);

    if (level == module.maxProgress) {
      _getANumberExerciseFromModule(sectionID, module.id, 30, context)
          .then((exercises) {
        _navigateToExercisesModule(
            sectionID, module, context, exercises, handler);
      });
    } else {
      _getExerciseFromModule(sectionID, module.id, level, context)
          .then((exercises) {
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

  int _getUserModuleLevel(BuildContext ctx, String sectionID, Module module) {
    final user = Provider.of<UserModel>(ctx, listen: false).user;

    try {
      final moduleProgress = user.sectionsProgress
          .firstWhere((section) => section.sectionId == sectionID)
          .modulesProgress
          .firstWhere((m) => m.moduleId == module.id);

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
