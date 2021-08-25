import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Network/Models/Module.dart';
import 'package:flutter/material.dart';

class MaduleWidget extends StatefulWidget {
  final Module _module;

  MaduleWidget(this._module);

  @override
  _MaduleWidgetState createState() => _MaduleWidgetState();
}

class _MaduleWidgetState extends State<MaduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.grey[600],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                value: 0.0,
                strokeWidth: 60,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
              ),
              CircleAvatar(
                child: Container(
                    height: 50, child: Image.network(widget._module.iconUrl)),
                radius: 35,
                backgroundColor: Colors.blue[400],
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
          SizedBox(height: 15),
          Text(widget._module.title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
