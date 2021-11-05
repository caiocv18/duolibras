import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/section.dart';
import 'package:duolibras/Services/Models/sectionProgress.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionPage {
  Section section;
  List<Module> modules;

  SectionPage(this.section, this.modules);
}

class WrapperSectionPage {
  List<SectionPage> pages;

  WrapperSectionPage(this.pages);

  List<Module> get _modules {
    List<Module> modules = [];
    pages.forEach((p) {
      modules.addAll(p.modules);
    });
    return modules;
  }

  Map<int, Section> _sectionsForIndex = {};

  bool get isEmpty {
    return pages.isEmpty;
  }

  int get total {
    int total = 0;

    pages.forEach((p) {
      total += p.modules.length;
    });

    return total;
  }

  Module moduleAtIndex(int index) {
    return _modules[index];
  }

  bool _isSectionAvaiable(
      List<SectionProgress> sectionsProgress, String sectionID) {
    try {
      final index =
          sectionsProgress.indexWhere((s) => s.sectionId == sectionID);

      if (index - 1 == -1) {
        return true;
      }

      return sectionsProgress.elementAt(index - 1).isCompleted;
    } catch (e) {
      return false;
    }
  }

  bool isModuleAvaiable(String sectionID, String moduleID, BuildContext ctx) {
    final sp =
        Provider.of<UserViewModel>(ctx, listen: false).user.sectionsProgress;

    if (!_isSectionAvaiable(sp, sectionID)) {
      return false;
    }

    try {
      final sectionProgress = sp.firstWhere((s) => s.sectionId == sectionID);
      final moduleIndex = sectionProgress.modulesProgress
          .indexWhere((m) => m.moduleId == moduleID);

      if (moduleIndex - 1 == -1) {
        return true; //quer dizer q é o primeiro da seção
      }

      return sectionProgress.modulesProgress
              .elementAt(moduleIndex - 1)
              .progress !=
          0; // Se for diferente de 0 quer dizer q o usuário já fez o módulo anterior
    } catch (e) {
      return false;
    }
  }

  Section? sectionAtIndex(int index) {
    int count = 0;
    for (var i = 0; i < pages.length; i++) {
      for (var j = 0; j < pages[i].modules.length; j++) {
        if (count == index) {
          return pages[i].section;
        }
        count += 1;
      }
    }
    return null;
  }

  int getCurrentTrailIndexByModuleProgress(String moduleID) {
    final index = _modules.indexWhere((m) => m.id == moduleID);
    return index;
  }
}
