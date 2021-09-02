import 'package:flutter/material.dart';

class InputAnswerWidget extends StatelessWidget {
  final TextEditingController inputController;

  InputAnswerWidget(this.inputController);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: constraint.maxWidth * 0.85,
        child: TextField(
            cursorColor: Colors.blue,
            decoration: InputDecoration(labelText: "Sua Resposta"),
            keyboardType: TextInputType.text,
            controller: inputController),
      );
    });
  }
}
