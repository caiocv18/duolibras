import 'dart:async';

import 'package:duolibras/Commons/Components/customAlert.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Modules/ErrorsModule/errorHandler.dart';
import 'package:duolibras/Modules/ExercisesModule/exerciseFlow.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/sectionPage.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Services/Models/exercise.dart';
import 'package:duolibras/Services/Models/exercisesCategory.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:duolibras/Services/Models/sectionProgress.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:duolibras/Commons/Extensions/list_extension.dart';

class LearningViewModel extends BaseViewModel
    with ModuleViewModel, LearningViewModelProtocol {
  final _errorHandler = ErrorHandler();
  bool isDisposed = false;
  List<Section> allSections = [];
  Map<Color, int> colorForModules = {};
  Map<int, int> sectionsForModules = {};
  WrapperSectionPage wrapperSectionPage = WrapperSectionPage([]);

  Future<void> _getModules(
      List<Section> newSections, BuildContext context) async {
    final sectionsProgress = Provider.of<UserViewModel>(context, listen: false)
        .user
        .sectionsProgress;

    for (var i = 0; i < newSections.length; i++) {
      await getModulesfromSection(newSections[i].id, context).then((modules) {
        wrapperSectionPage.pages.add(SectionPage(newSections[i], modules));
        Color color = modules.first.color;
        colorForModules.addAll({color: modules.length});
        sectionsForModules.addAll({i: modules.length});
      });
    }

    if (sectionsProgress.length != newSections.length) {
      wrapperSectionPage.pages.forEach((page) {
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
    } else {
      var contains;
      for (var i = 0; i < wrapperSectionPage.pages.length; i++) {
        wrapperSectionPage.pages[i].modules.forEach((module) {
          contains = false;
          sectionsProgress[i].modulesProgress.forEach((moduleProgress) {
            if (module.id == moduleProgress.moduleId) {
              contains = true;
            }
          });

          if (!contains) {
            sectionsProgress[i].modulesProgress.add(ModuleProgress(
                id: UniqueKey().toString(),
                moduleId: module.id,
                progress: 0,
                maxModuleProgress: module.maxProgress));
          }
        });
      }
    }

    SharedFeatures.instance
        .setNumberMaxOfModules(wrapperSectionPage.totalModules);
    if (!this.isDisposed) {
      setState(ScreenState.Normal);
    }
  }

  Future<List<Module>> getModulesfromSection(
      String sectionID, BuildContext context) async {
    return Service.instance
        .getModulesFromSectionId(sectionID)
        .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Module>> completer = Completer<List<Module>>();

      _errorHandler.showModal(appError, context,
          enableDrag: false,
          tryAgainClosure: () => _errorHandler.tryAgainClosure(
              () => Service.instance.getModulesFromSectionId(sectionID),
              context,
              completer));
      return completer.future;
    });
  }

  Future<List<Section>> getSectionsFromTrail(BuildContext context) {
    return Service.instance.getSectionsFromTrail().onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Section>> completer = Completer<List<Section>>();

      _errorHandler.showModal(appError, context,
          enableDrag: false,
          tryAgainClosure: () => _errorHandler.tryAgainClosure(
              () => Service.instance.getSectionsFromTrail(),
              context,
              completer));
      return completer.future;
    });
  }

  @override
  Future<void> fetchSections(BuildContext context) async {
    setState(ScreenState.Loading);

    await getSectionsFromTrail(context).then((newSections) {
      hasMore = false;
      allSections.addAll(newSections);
      _getModules(newSections, context);
    });
  }

  Future<List<Exercise>> _getExerciseFromModule(
      String sectionID, String moduleID, int level, BuildContext context) {
    return Service.instance
        .getExercisesFromModuleId(sectionID, moduleID, level)
        .onError((error, stackTrace) {
      final appError = Utils.logAppError(error);
      Completer<List<Exercise>> completer = Completer<List<Exercise>>();

      _errorHandler.showModal(appError, context,
          tryAgainClosure: () => _errorHandler.tryAgainClosure(
              () => Service.instance
                  .getExercisesFromModuleId(sectionID, moduleID, level),
              context,
              completer),
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
          tryAgainClosure: () => _errorHandler.tryAgainClosure(
              () => Service.instance.getANumberOfExercisesFromModuleId(
                  sectionID, moduleID, quantity),
              context,
              completer),
          exitClosure: () => completer.complete([]));
      return completer.future;
    }).then((exercises) {
      exercises.shuffle();
      List<Exercise> newExercises = [];

      for (var i = 0; i < quantity; i++) {
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
    if (state != ScreenState.Normal) {
      return;
    }

    setState(ScreenState.Loading);
    final level = _getUserModuleLevel(context, sectionID, module);

    if (level > module.maxProgress) {
      _getANumberExerciseFromModule(sectionID, module.id, 20, context)
          .then((exercises) {
        exercises = exercises
            .where((element) => element.category != ExercisesCategory.content)
            .toList();
        setState(ScreenState.Normal);
        if (exercises.isNotEmpty) {
          _checkIfCameraIsEnabled(exercises, context).then((value) {
            _navigateToExercisesModule(sectionID, module, value, handler);
          });
        }
      });
    } else {
      _getExerciseFromModule(sectionID, module.id, level, context)
          .then((exercises) {
        setState(ScreenState.Normal);
        if (exercises.isNotEmpty) {
          _checkIfCameraIsEnabled(exercises, context).then((value) {
            _navigateToExercisesModule(sectionID, module, value, handler);
          });
        }
      });
    }
  }

  Future<List<Exercise>> _checkIfCameraIsEnabled(
      List<Exercise> exercises, BuildContext context) async {
    Completer<List<Exercise>> completer = Completer();

    if (exercises.indexWhere((element) =>
            element.category == ExercisesCategory.ml ||
            element.category == ExercisesCategory.mlSpelling) ==
        -1) {
      return exercises;
    }

    final permission = Permission.camera;
    final isGranted = await permission.isGranted;

    if (!isGranted) {
      if (await permission.isPermanentlyDenied) {
        return _showDialog(exercises);
      } else {
        Permission.camera.request().then((value) {
          if (value.isGranted) {
            completer.complete(exercises);
          } else {
            completer.complete(_showDialog(exercises));
          }
        });
      }
    } else {
      completer.complete(exercises);
    }

    return completer.future;
  }

  Future<List<Exercise>> _showDialog(List<Exercise> exercises) async {
    Completer<List<Exercise>> completer = Completer();

    var newExercises = exercises
        .where((element) =>
            element.category != ExercisesCategory.mlSpelling &&
            element.category != ExercisesCategory.ml)
        .toList();
    setState(ScreenState.Normal);
    final context = MainRouter.instance.navigatorKey.currentContext;

    if (context == null) {
      return newExercises;
    }

    await showDialog<bool>(
        context: context,
        builder: (context) {
          return CustomAlert(
              title:
                  "Vá nas configurações para habilitar a câmera e aproveitar o melhor do App, com os exercícios práticos!",
              yesTitle: "Permitir",
              noTitle: "Ok",
              yesButton: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              noButton: () {
                Navigator.of(context).pop();
                completer.complete(newExercises);
              });
        });

    return completer.future;
  }

  void _navigateToExercisesModule(String sectionID, Module module,
      List<Exercise> exercises, Function? handler) {
    if (MainRouter.instance.navigatorKey.currentState == null) {
      return;
    }

    MainRouter.instance.navigatorKey.currentState!
        .pushNamed(ExerciseFlow.routePrefixExerciseFlow, arguments: {
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
    final user = Provider.of<UserViewModel>(ctx, listen: false).user;

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

  int shouldAnimatedTrail(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    final idOfLastModuleIncremented = userProvider.idOfLastModuleIncremented;

    if (idOfLastModuleIncremented == null) {
      return -1;
    }

    final index = wrapperSectionPage
        .getCurrentTrailIndexByModuleProgress(idOfLastModuleIncremented);

    if (index == -1) {
      return -1;
    }

    if (index == userProvider.user.trailSectionIndex) {
      return -1;
    }

    userProvider.trailSectionIndex(index);
    Service.instance.postUser(userProvider.user, false);

    return index;
  }
}
