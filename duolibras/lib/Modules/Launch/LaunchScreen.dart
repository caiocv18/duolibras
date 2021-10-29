import 'dart:ui';

import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/Launch/launchViewModel.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';

import 'Widgets/circularProgressIndicator.dart';


class LaunchScreen extends StatefulWidget {
  final Function _loadCompleted;
  final viewModel = LaunchViewModel();

  LaunchScreen(this._loadCompleted);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with SingleTickerProviderStateMixin {
  var animated = false;
  var isGettingUser = false;
  var isDownloaded = false;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    getUser();
    super.initState();
  }

  void getUser() {
    widget.viewModel.getInitialData(this.context).then((value) => {
      widget._loadCompleted()
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      body: 
        SafeArea(
          child: LayoutBuilder(builder: (ctx, constraint) {
                return SingleChildScrollView(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: 
                    [
                      Container(
                        height: constraint.maxHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                Constants.imageAssets.background_home),
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                      Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Text("Preparando ambiente...", 
                          style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, fontSize: 24)),
                        SizedBox(height: 30),
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                          child: GradientCircularProgressIndicator(
                            radius: 50,
                            gradientColors: [HexColor.fromHex("4982F6"), HexColor.fromHex("2CC4FC")],
                            strokeWidth: 10.0,
                          ),
                        ),
                      ],
                    )
                    ],
                  ),
                );
          })
      ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
    
}
