import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';

import '../sectionProgress.dart';

class UserViewModel extends BaseViewModel {
  User? _user;

  User get user {
    if (_user != null) {
      var user = User(
          name: _user!.name,
          email: _user!.email,
          id: _user!.id,
          currentProgress: _user!.currentProgress,
          trailSectionIndex: _user!.trailSectionIndex,
          imageUrl: _user!.imageUrl);

      user.sectionsProgress = _user!.sectionsProgress;
      return user;
    }

    return User(
        name: "",
        email: ",",
        id: "",
        currentProgress: 0,
        trailSectionIndex: -99,
        imageUrl: null);
  }

  String? _idOfLastModuleIncremented;

  String? get idOfLastModuleIncremented {
    return _idOfLastModuleIncremented;
  }

  void _getIdOfLastModuleIncremented(ModuleProgress moduleProgress) {
    if (moduleProgress.progress == moduleProgress.maxModuleProgress) {
      _idOfLastModuleIncremented = moduleProgress.moduleId;
      return;
    }
    _idOfLastModuleIncremented = null;
  }

  void setNewUser(User newUser) {
    _user = newUser;
    setState(ScreenState.Normal);
  }

  void setImageUrl(String url) {
    if (_user != null) {
      _user!.imageUrl = url;
      setState(ScreenState.Normal);
    }
  }

  void setModulesProgress(String sectionId, ModuleProgress moduleProgress) {
    if (_user != null) {
      final index = _user!.sectionsProgress
          .indexWhere((section) => section.sectionId == sectionId);

      final modulesIndex = _user!.sectionsProgress[index].modulesProgress
          .indexWhere((md) => md.moduleId == moduleProgress.id);
      if (modulesIndex != -1) {
        _user!.sectionsProgress[index].modulesProgress[modulesIndex] =
            moduleProgress;
        setState(ScreenState.Normal);
        return;
      }
      _user!.sectionsProgress
          .firstWhere((section) => section.sectionId == sectionId)
          .modulesProgress
          .add(moduleProgress);
      setState(ScreenState.Normal);
    }
  }

  void trailSectionIndex(int index) {
    if (_user != null) {
      _user!.trailSectionIndex = index;
    }
  }

  SectionProgress? incrementModulesProgress(
      String sectionId, moduleID, int maxModuleProgress) {
    if (_user != null) {
      final sectionIndex = _user!.sectionsProgress
          .indexWhere((section) => section.sectionId == sectionId);

      final modulesIndex = _user!.sectionsProgress[sectionIndex].modulesProgress
          .indexWhere((md) => md.moduleId == moduleID);
      if (modulesIndex != -1) {
        if (_user!.sectionsProgress[sectionIndex].modulesProgress[modulesIndex]
                    .progress +
                1 >
            _user!.sectionsProgress[sectionIndex].modulesProgress[modulesIndex]
                    .maxModuleProgress +
                1) {
          setState(ScreenState.Normal);
          return _user!.sectionsProgress[sectionIndex];
        }

        _user!.sectionsProgress[sectionIndex].modulesProgress[modulesIndex]
            .progress += 1;

        _getIdOfLastModuleIncremented(_user!
            .sectionsProgress[sectionIndex].modulesProgress[modulesIndex]);

        setState(ScreenState.Normal);
        return _user!.sectionsProgress[sectionIndex];
      }

      ModuleProgress newModule = ModuleProgress(
          id: UniqueKey().toString(),
          moduleId: moduleID,
          progress: 1,
          maxModuleProgress: maxModuleProgress);
      _user!.sectionsProgress[sectionIndex].modulesProgress.add(newModule);

      _getIdOfLastModuleIncremented(newModule);
      setState(ScreenState.Normal);

      return _user!.sectionsProgress[sectionIndex];
    }
    return null;
  }

  void addSectionProgress(SectionProgress sectionProgress) {
    if (_user != null) {
      _user!.sectionsProgress.add(sectionProgress);
      setState(ScreenState.Normal);
      return;
    }
    setState(ScreenState.Normal);
  }

  void setUserName(String name) {
    if (_user != null) {
      _user!.name = name;
      setState(ScreenState.Normal);
    }
  }

  void incrementUserProgress(int amount) {
    if (_user != null) {
      _user!.currentProgress += amount;
      setState(ScreenState.Normal);
    }
  }
}
