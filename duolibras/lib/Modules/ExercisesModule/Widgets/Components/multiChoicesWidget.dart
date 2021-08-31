import 'package:flutter/material.dart';

class MultiChoicesWidget extends StatelessWidget {
  final List<String> _answers;
  Function _handleQuestion;

  MultiChoicesWidget(this._answers, this._handleQuestion);

  Widget _createButton(String title, BoxConstraints constraint) {
    return Column(
      children: [
        Container(
          height: constraint.maxHeight * 0.15,
          width: constraint.maxWidth * 0.7,
          child: ElevatedButton(
            child: Text(title),
            onPressed: () {
              _handleQuestion(title);
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blue)))),
          ),
        ),
        SizedBox(height: constraint.maxHeight * 0.04)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
          child: Column(children: [
        ..._answers.map((answer) {
          return _createButton(answer, constraint);
        }).toList()
      ]));
    });
  }
}
