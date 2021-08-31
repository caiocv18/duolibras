import 'dart:async';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Section.dart';
import 'package:flutter/material.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';

abstract class SectionsViewModel {
  Future<List<Section>> getSectionsFromTrail(String id);
  Future<List<Module>> getModulesfromSection(String sectionID);
}

class SectionWidget extends StatefulWidget {
  final Section _section;
  final SectionsViewModel _viewModel;
  SectionWidget(this._section, this._viewModel);

  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  List<Module>? _modules = null;

  @override
  void initState() {
    super.initState();
    _getModules();
  }

  void _getModules() {
    widget._viewModel
        .getModulesfromSection(widget._section.id)
        .then((newModules) {
      setState(() {
        this._modules = newModules;
      });
    });
  }

  Widget _twoModulesWidget(MaduleWidget m1, MaduleWidget m2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [m1, SizedBox(width: 50), m2],
    );
  }

  Widget _oneModulesWidget(MaduleWidget m) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [m],
    );
  }

  Widget _createLoadingWidget() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: CircularProgressIndicator(),
    ));
  }

  Widget _createSectionsWidgets() {
    final numberOfModules = _modules!.length;
    final viewModel = widget._viewModel as ModuleViewModel;
    switch (numberOfModules) {
      case 4:
        return Column(children: [
          _twoModulesWidget(
              MaduleWidget(_modules![0], widget._section.id, viewModel),
              MaduleWidget(_modules![1], widget._section.id, viewModel)),
          SizedBox(height: 30),
          _twoModulesWidget(
              MaduleWidget(_modules![2], widget._section.id, viewModel),
              MaduleWidget(_modules![3], widget._section.id, viewModel))
        ]);
      case 3:
        return Column(children: [
          _oneModulesWidget(
              MaduleWidget(_modules![0], widget._section.id, viewModel)),
          SizedBox(height: 30),
          _twoModulesWidget(
              MaduleWidget(_modules![1], widget._section.id, viewModel),
              MaduleWidget(_modules![2], widget._section.id, viewModel))
        ]);
      case 2:
        return Column(children: [
          _twoModulesWidget(
              MaduleWidget(_modules![0], widget._section.id, viewModel),
              MaduleWidget(_modules![1], widget._section.id, viewModel)),
        ]);
      default:
        return _oneModulesWidget(
            MaduleWidget(_modules![0], widget._section.id, viewModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        widget._section.title,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 30),
      (_modules == null) ? _createLoadingWidget() : _createSectionsWidgets()
    ]);
  }
}
