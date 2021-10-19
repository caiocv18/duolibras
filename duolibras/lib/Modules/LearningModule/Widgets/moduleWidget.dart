import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
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
  final MainAxisAlignment _rowAlignment;
  final Function _handleFinishExercises;
  final bool _isAvaiable;
  MaduleWidget(this._module, this.sectionID, this._viewModel,
      this._rowAlignment, this._handleFinishExercises, this._isAvaiable);

  @override
  _MaduleWidgetState createState() => _MaduleWidgetState();
}

class _MaduleWidgetState extends State<MaduleWidget> {
  double _getModulerProgress(User user) {
    if (user.sectionsProgress.isEmpty) return 0;

    var sectionProgress = user.sectionsProgress;

    try {
      final moduleProgress = sectionProgress
          .firstWhere((s) => s.sectionId == widget.sectionID)
          .modulesProgress;

      if (moduleProgress.isEmpty) return 0;

      return moduleProgress
              .firstWhere((m) => m.moduleId == widget._module.id)
              .progress /
          widget._module.maxProgress;
    } on StateError catch (_) {
      return 0;
    }
  }

  void _handleCompleModule(bool? completed) {
    if (completed == null) return;

    if (completed) {
      widget._handleFinishExercises();
      // setState(() {});
    }
  }

  var colors = [
    Colors.amber,
    Colors.grey,
    Colors.blue,
    Colors.orange,
    Colors.green
  ];
  @override
  Widget build(BuildContext context) {
    colors.shuffle();
    return Container(
      // color: colors.first,
      height: 200,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: widget._rowAlignment,
                children: _createRowContent(),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _createRowContent() {
    return widget._rowAlignment == MainAxisAlignment.start
        ? [
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
                      backgroundColor: HexColor.fromHex("D2D7E4"),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(255, 215, 0, 1)),
                      value: _getModulerProgress(userProvider.user),
                      strokeWidth: 60,
                    );
                  }),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Container(
                        // height: 50,
                        child:
                            Image.network(widget._module.backgroundImageUrl)),
                  ),
                  CircleAvatar(
                    child: Container(
                        height: 50,
                        child: Image.network(widget._module.iconUrl)),
                    radius: 35,
                    backgroundColor:
                        1 == _getModulerProgress(locator<UserModel>().user)
                            ? Colors.transparent
                            : Colors.transparent,
                  ),
                  if (!widget._isAvaiable)
                    Stack(alignment: Alignment.center, children: [
                      CircleAvatar(
                        backgroundColor: HexColor.fromHex("D2D7E4"),
                        radius: 50,
                      ),
                      CircleAvatar(
                        child: Container(
                            height: 50,
                            child: Icon(
                              Icons.lock,
                              color: HexColor.fromHex("4982F6"),
                            )),
                        radius: 35,
                        backgroundColor: HexColor.fromHex("D2D7E4"),
                      )
                    ])
                ],
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              child: Text(widget._module.title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            )
          ]
        : [
            Flexible(
              child: Text(widget._module.title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            SizedBox(width: 20),
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
                      backgroundColor: HexColor.fromHex("D2D7E4"),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(255, 215, 0, 1)),
                      value: _getModulerProgress(userProvider.user),
                      strokeWidth: 60,
                    );
                  }),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Container(
                        // height: 50,
                        child:
                            Image.network(widget._module.backgroundImageUrl)),
                  ),
                  CircleAvatar(
                    child: Container(
                        height: 50,
                        child: Image.network(widget._module.iconUrl)),
                    radius: 35,
                    backgroundColor:
                        1 == _getModulerProgress(locator<UserModel>().user)
                            ? Colors.transparent
                            : Colors.transparent,
                  ),
                  if (!widget._isAvaiable)
                    Stack(alignment: Alignment.center, children: [
                      CircleAvatar(
                        backgroundColor: HexColor.fromHex("D2D7E4"),
                        radius: 50,
                      ),
                      CircleAvatar(
                        child: Container(
                            height: 50,
                            child: Icon(
                              Icons.lock,
                              color: HexColor.fromHex("4982F6"),
                            )),
                        radius: 35,
                        backgroundColor: HexColor.fromHex("D2D7E4"),
                      )
                    ])
                ],
              ),
            )
          ];
  }
}
