
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:flutter/material.dart';

class BoundingBox extends StatelessWidget {
  
  const BoundingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kGradientBoxDecoration = BoxDecoration(
      color: Colors.transparent,
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [HexColor.fromHex("4982F6"), HexColor.fromHex("2CC4FC")]),
    );

    return Container(
      height: 145,
      width: 145,
      child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
      decoration: kGradientBoxDecoration,
    );
  }
}

