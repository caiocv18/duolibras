import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ModuleViewModel {
  Future<void> didSelectModule(
      String sectionID, Module module, BuildContext context, Function? handler);
}

class MaduleWidget extends StatefulWidget {
  final Module _module;
  final ModuleViewModel _viewModel;
  final String sectionID;

  MaduleWidget(this._module, this.sectionID, this._viewModel);

  @override
  _MaduleWidgetState createState() => _MaduleWidgetState();
}

class _MaduleWidgetState extends State<MaduleWidget> {
  double _getModulerProgress(User user) {
    if (user.modulesProgress.isEmpty) return 0;

    var progresses = user.modulesProgress;

    final moduleProgress =
        progresses.where((p) => p.moduleId == widget._module.id);

    if (moduleProgress.isEmpty) return 0;

    return moduleProgress.first.progress / widget._module.maxProgress;
  }

  void _handleCompleModule(bool? completed) {
    if (completed == null) return;

    if (completed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              widget._viewModel.didSelectModule(widget.sectionID,
                  widget._module, context, _handleCompleModule);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Consumer(builder: (ctx, UserModel userProvider, _) {
                  return CircularProgressIndicator(
                    backgroundColor: Colors.grey[600],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(255, 215, 0, 1)),
                    value: _getModulerProgress(userProvider.user),
                    strokeWidth: 60,
                  );
                }),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                ),
                CircleAvatar(
                  child: Container(
                      height: 50, child: Image.network(widget._module.iconUrl)),
                  radius: 35,
                  backgroundColor:
                      1 == _getModulerProgress(locator<UserModel>().user)
                          ? Color.fromRGBO(255, 215, 0, 1)
                          : Colors.blue[400],
                ),
                if (widget._module.minProgress >
                    SharedFeatures.instance.userProgress)
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
          Text(widget._module.title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
