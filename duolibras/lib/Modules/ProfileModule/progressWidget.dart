import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressWidget extends StatelessWidget {
  final double progress;
  ProgressWidget(this.progress);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 60.0,
                    color: Colors.red,
                    backgroundColor: Colors.blueAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                SizedBox(width: 80),
          getTitle()
        ],
      ),
    );
  }

  Text getTitle() {
    var text = "";

    if (progress <= 0.25){
      text = "Iniciante";
    } else if (progress <= 0.5){
      text = "Intermediário";
    }
    else if (progress <= 0.75){
      text = "Avançado";
    }
    else {
      text = "Mestre";
    }
    return Text(text);
  }

}