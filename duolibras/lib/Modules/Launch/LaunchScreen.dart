import 'dart:ui';

import 'package:duolibras/Commons/Utils/serviceLocator.dart';
import 'package:duolibras/Modules/Launch/launchViewModel.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/service.dart';
import 'package:flutter/material.dart';


class LaunchScreen extends StatefulWidget {
  final Function _loadCompleted;
  final viewModel = LaunchViewModel();

  LaunchScreen(this._loadCompleted);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  var animated = false;
  var isGettingUser = false;
  var isDownloaded = false;

  @override
  void initState() {
    super.initState();
    getUser();
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
          child: 
            Center(
                child: 
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Preparando o ambiente...", 
                      style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, fontSize: 20)),
                    SizedBox(height: 15),
                    CircularProgressIndicator(color: Colors.black)
                  ],
                )
            ),
          ),
      );
  }
    
}
