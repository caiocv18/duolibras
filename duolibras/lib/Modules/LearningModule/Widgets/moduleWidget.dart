import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Services/Models/module.dart';
import 'package:duolibras/Services/Models/Providers/userViewModel.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ModuleViewModel {
  Future<void> didSelectModule(
      String sectionID, Module module, BuildContext context, Function? handler);
}

class ModuleWidget extends StatefulWidget {
  final Module _module;
  final ModuleViewModel _viewModel;
  final String sectionID;
  final MainAxisAlignment _rowAlignment;
  final Function _handleFinishExercises;
  final bool _isAvaiable;
  ModuleWidget(this._module, this.sectionID, this._viewModel,
      this._rowAlignment, this._handleFinishExercises, this._isAvaiable);

  @override
  _ModuleWidgetState createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  double _getModuleProgress(User user) {
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
    return LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
      final leftPadding =
          widget._rowAlignment == MainAxisAlignment.start ? 50.0 : 0.0;
      final rightPadding =
          widget._rowAlignment == MainAxisAlignment.end ? 50.0 : 0.0;

      return Padding(
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Container(
          // color: colors.first,
          height: 200,
          width: constraints.maxWidth * 0.9,
          child: _buildBody(widget._rowAlignment),
        ),
      );
    });
  }

  Widget _buildBody(MainAxisAlignment alignment) {
    return Consumer(builder: (ctx, UserViewModel userProvider, _) {
      return Row(mainAxisAlignment: alignment, children: [
        if (alignment != MainAxisAlignment.start)
          Flexible(
            child: Text(widget._module.title,
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              if (widget._isAvaiable)
                widget._viewModel.didSelectModule(widget.sectionID,
                    widget._module, context, _handleCompleteModule);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget._isAvaiable)
                  _buildIcon(userProvider.user)
                else
                  _buildUnavailableIcon()
              ],
            ),
          ),
        ),
        if (alignment == MainAxisAlignment.start)
          Flexible(
            child: Text(widget._module.title,
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
      ]);
    });
  }

  Widget _buildIcon(User user) {
    return Stack(alignment: Alignment.center, children: [
      CircularProgressIndicator(
        backgroundColor: HexColor.fromHex("D2D7E4"),
        valueColor:
            AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 215, 0, 1)),
        value: _getModuleProgress(user),
        strokeWidth: 60,
      ),
      CircleAvatar(
        backgroundColor: Colors.white,
        radius: 40,
        child:
            Container(child: Image.network(widget._module.backgroundImageUrl)),
      ),
      CircleAvatar(
        child:
            Container(height: 50, child: Image.network(widget._module.iconUrl)),
        radius: 35,
        backgroundColor: 1 == _getModuleProgress(locator<UserViewModel>().user)
            ? Colors.transparent
            : Colors.transparent,
      )
    ]);
  }

  Widget _buildUnavailableIcon() {
    return Stack(alignment: Alignment.center, children: [
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
    ]);
  }

  void _handleCompleteModule(bool? completed) {
    if (completed == null) return;

    if (completed) {
      widget._handleFinishExercises();
      // setState(() {});
    }
  }
}
