import 'dart:async';

import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/sectionWidget.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:duolibras/Commons/Extensions/list_extension.dart';

class LearningViewModel with SectionsViewModel, ModuleViewModel, LearningViewModelProtocol {
  final _errorHandler = ErrorHandler();
  List<String> allSectionsID = [];
  BehaviorSubject<List<Section>> _controller = BehaviorSubject<List<Section>>();

  List<Section> allSections = [];
  LearningViewModel() {
    sections = _controller.stream;
  }

  @override
  Future<List<Module>> getModulesfromSection(String sectionID, BuildContext context) async {
    return Service.instance.getModulesFromSectionId(sectionID)
    .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Module>> completer = Completer<List<Module>>();

      _errorHandler.showModal(appError, context, enableDrag: false,
      tryAgainClosure: () => _errorHandler.tryAgainClosure(() => 
      Service.instance.getModulesFromSectionId(sectionID), context, completer),  
      exitClosure: () => completer.complete([]));
      return completer.future;
    });
  }

  @override
  Future<List<Section>> getSectionsFromTrail(BuildContext context) {
    return Service.instance.getSectionsFromTrail()
    .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Section>> completer = Completer<List<Section>>();

      _errorHandler.showModal(appError, context, enableDrag: false,
      tryAgainClosure: () => _errorHandler.tryAgainClosure(() => 
      Service.instance.getSectionsFromTrail(), context, completer), 
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
      _controller.sink.add(newSections);
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

  Future<List<Exercise>> _getANumberExerciseFromModule(String sectionID, String moduleID, int quantity, BuildContext context) {
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
  Future<void> didSelectModule(String sectionID, Module module,BuildContext context, Function? handler) async {
    final level = _getUserModuleLevel(context, module);

    if (level == module.maxProgress) {
      _getANumberExerciseFromModule(sectionID, module.id, 30, context).then((exercises) {
        _navigateToExercisesModule(sectionID, module, context, exercises, handler);
      });
    } else {
      _getExerciseFromModule(sectionID, module.id, level, context).then((exercises) {
        _navigateToExercisesModule(sectionID, module, context, exercises, handler);
      });
    }
  }

  void _navigateToExercisesModule(String sectionID, Module module,BuildContext context, List<Exercise> exercises, Function? handler) {
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
