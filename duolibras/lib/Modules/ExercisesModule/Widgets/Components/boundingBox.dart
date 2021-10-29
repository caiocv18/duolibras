
import 'package:flutter/material.dart';

class BoundingBox extends StatelessWidget {
  
  const BoundingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3.0)));
  }
}

