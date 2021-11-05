import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Services/Models/appError.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ErrorScreenState { Loading, Normal }

class ErrorScreen extends StatefulWidget {
  Function? _exitClosure;
  Function? _tryAgainClosure;
  Function(ErrorScreenState)? changeScreenState;
  AppError _error;

  ErrorScreen(this._error, this._tryAgainClosure, this._exitClosure);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  var state = ErrorScreenState.Normal;

  @override
  void initState() {
    widget.changeScreenState = (state) {
      setState(() {
        this.state = state;
      });
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paddingTop = MediaQueryData.fromWindow(window).padding.top;
    final containerHeight = mediaQuery.size.height - paddingTop;
    final containerSize = Size(mediaQuery.size.width, containerHeight);

    return Material(
        color: Colors.transparent,
        child: Container(
            width: double.infinity,
            height: containerHeight * 0.9,
            child: _buildBody(containerSize, context)));
  }

  Widget _buildBody(Size containerSize, BuildContext ctx) {
    return Container(
      height: containerSize.height * 0.9,
      decoration: BoxDecoration(
        color: Color.fromRGBO(234, 234, 234, 1),
        image: DecorationImage(
          image: AssetImage(Constants.imageAssets.background_home),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Color.fromRGBO(234, 234, 234, 1)),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget._exitClosure != null)
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 10),
                child: _buildExitButton(ctx),
              )
            ]),
          SizedBox(
              height: widget._tryAgainClosure == null
                  ? containerSize.height * 0.1
                  : containerSize.height * 0.04),
          Container(
            width: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildImage(containerSize),
              SizedBox(height: containerSize.height * 0.04),
              _buildDescriptionText(),
              if (widget._tryAgainClosure != null)
                Container(
                    child: Column(children: [
                  SizedBox(height: containerSize.height * 0.1),
                  _buildTryAgainButton(containerSize)
                ]))
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildExitButton(BuildContext ctx) {
    return GestureDetector(
        child: Icon(Icons.close),
        onTap: () {
          Navigator.of(ctx).pop();
          if (widget._exitClosure != null) widget._exitClosure!();
        });
  }

  Widget _buildDescriptionText() {
    final answer = widget._error.description;
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
          width: constraint.maxWidth * 0.89,
          child: Center(
            child: Text(
              answer,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w500),
            ),
          ));
    });
  }

  Widget _buildImage(Size containerSize) {
    return Center(
        child: Container(
      width: containerSize.width * 0.8,
      height: containerSize.height * 0.35,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
          child: Image(image: AssetImage(Constants.imageAssets.sadFace))),
    ));
  }

  Widget _buildTryAgainButton(Size containerSize) {
    if (state == ErrorScreenState.Normal) {
      return Container(
        height: 50,
        width: 250,
        child: ExerciseButton(
          child: Center(
            child: Text("Tentar novamente",
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w500)),
          ),
          size: 30,
          color: HexColor.fromHex("#93CAFA"),
          onPressed: () => () {
            if (widget._tryAgainClosure != null) widget._tryAgainClosure!();
          },
        ),
        // TextButton(
        //   style: TextButton.styleFrom(
        //     padding: const EdgeInsets.all(12.0),
        //     primary: Colors.white,
        //     textStyle: const TextStyle(
        //         fontSize: 20,
        //         fontFamily: "Nunito",
        //         fontWeight: FontWeight.w700),
        //   ),
        // onPressed: () {
        //   if (widget._tryAgainClosure != null) widget._tryAgainClosure!();
        // },
        //   child: const Text('Tentar novamente'),
        // ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }
  }
}
