import 'dart:async';
import 'dart:developer';

import 'package:duolibras/Commons/ViewModel/ScreenState.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/ModuleProgress.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:duolibras/Network/Service.dart';
import 'package:flutter/material.dart';

import '../sectionProgress.dart';

class UserModel extends BaseViewModel {
  User? _user;

  User get user {
    if (_user != null) {
      var user = User(
          name: _user!.name,
          email: _user!.email,
          id: _user!.id,
          currentProgress: _user!.currentProgress,
          imageUrl: _user!.imageUrl);
      user.sectionsProgress = _user!.sectionsProgress;
      return user;
    }

    return User(
        name: "", email: ",", id: "", currentProgress: 0, imageUrl: null);
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

  void incrementModulesProgress(
      String sectionId, moduleID, int maxModuleProgress) {
    if (_user != null) {
      final sectionIndex = _user!.sectionsProgress
          .indexWhere((section) => section.sectionId == sectionId);

      final modulesIndex = _user!.sectionsProgress[sectionIndex].modulesProgress
          .indexWhere((md) => md.moduleId == moduleID);
      if (modulesIndex != -1) {
        if (_user!.sectionsProgress[modulesIndex].modulesProgress[modulesIndex]
                    .progress +
                1 >
            _user!.sectionsProgress[modulesIndex].modulesProgress[modulesIndex]
                .maxModuleProgress) {
          setState(ScreenState.Normal);
          return;
        }

        _user!.sectionsProgress[modulesIndex].modulesProgress[modulesIndex]
            .progress += 1;
        setState(ScreenState.Normal);
        return;
      }

      _user!.sectionsProgress[sectionIndex].modulesProgress.add(ModuleProgress(
          id: UniqueKey().toString(),
          moduleId: moduleID,
          progress: 1,
          maxModuleProgress: maxModuleProgress));
      setState(ScreenState.Normal);
    }
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
}
