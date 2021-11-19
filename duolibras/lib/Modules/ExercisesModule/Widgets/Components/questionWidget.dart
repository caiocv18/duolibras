import 'package:auto_size_text/auto_size_text.dart';
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
                child: Container(
                  // height: 37,
                  // color: Colors.red,
                  child: AutoSizeText(
                    _question,
                    maxLines: 2,
                    minFontSize: 20,
                    maxFontSize: 24,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ])),
      );
    });
  }
}
