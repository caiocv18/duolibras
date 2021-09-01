import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:flutter/material.dart';

abstract class ModuleViewModel {
  Future<void> didSelectModule(
      String sectionID, String moduleID, BuildContext context);
}

class MaduleWidget extends StatelessWidget {
  final Module _module;
  final ModuleViewModel _viewModel;
  final String sectionID;

  MaduleWidget(this._module, this.sectionID, this._viewModel);

  double _getModulerProgress() {
    if (UserSession.instance.user == null) return 0;

    if (UserSession.instance.user!.modulesProgress == null) return 0;

    print("User ${UserSession.instance.user}");
    var progresses = UserSession.instance.user!.modulesProgress!;

    final moduleProgress = progresses.where((p) => p.moduleId == _module.id);

    if (moduleProgress == null || moduleProgress.isEmpty) return 0;

    return moduleProgress.first.progress / _module.maxProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _viewModel.didSelectModule(sectionID, _module.id, context);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.grey[600],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  value: _getModulerProgress(),
                  strokeWidth: 60,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                ),
                CircleAvatar(
                  child: Container(
                      height: 50, child: Image.network(_module.iconUrl)),
                  radius: 35,
                  backgroundColor: Colors.blue[400],
                ),
                if (_module.minProgress > SharedFeatures.instance.userProgress)
                  Stack(alignment: Alignment.center, children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 50,
                    ),
                    CircleAvatar(
                      child: Container(height: 50, child: Icon(Icons.lock)),
                      radius: 35,
                      backgroundColor: Colors.grey,
                    )
                  ])
              ],
            ),
          ),
          SizedBox(height: 15),
          Text(_module.title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
