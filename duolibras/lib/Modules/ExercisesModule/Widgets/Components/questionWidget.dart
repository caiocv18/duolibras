import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String _question;

  QuestionWidget(this._question);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Center(
        child: Container(
            width: constraint.maxWidth * 0.85,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Text(
                  _question,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              )
            ])),
      );
    });
  }
}
