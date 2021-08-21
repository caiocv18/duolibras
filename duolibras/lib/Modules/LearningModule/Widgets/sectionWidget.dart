import 'package:flutter/material.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/moduleWidget.dart';

class SectionWidget extends StatelessWidget {
  Widget _twoModulesWidget(MaduleWidget m1, MaduleWidget m2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [m1, SizedBox(width: 50), m1],
    );
  }

  Widget _oneModulesWidget(MaduleWidget m) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [m],
    );
  }

  Widget _createWidgets() {
    if (_numberOfModules == 3) {
      return Column(children: [
        _oneModulesWidget(MaduleWidget()),
        SizedBox(height: 30),
        _twoModulesWidget(MaduleWidget(), MaduleWidget())
      ]);
    } else if (_numberOfModules == 4) {
      return Column(children: [
        _twoModulesWidget(MaduleWidget(), MaduleWidget()),
        SizedBox(height: 30),
        _twoModulesWidget(MaduleWidget(), MaduleWidget())
      ]);
    } else if (_numberOfModules == 2) {
      return Column(children: [
        _twoModulesWidget(MaduleWidget(), MaduleWidget()),
      ]);
    } else {
      return _oneModulesWidget(MaduleWidget());
    }
  }

  final int _numberOfModules;
  final String _title;

  SectionWidget(this._title, this._numberOfModules);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        _title,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 30),
      _createWidgets()
    ]);
  }
}
