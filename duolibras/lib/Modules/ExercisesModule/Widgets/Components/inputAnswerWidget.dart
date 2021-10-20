import 'package:flutter/material.dart';

class InputAnswerWidget extends StatefulWidget {
  final TextEditingController inputController;
  final bool isEnable;
  final String placeHolder;
  InputAnswerWidget(this.inputController, this.isEnable, this.placeHolder);

  @override
  State<InputAnswerWidget> createState() => _InputAnswerWidgetState();
}

class _InputAnswerWidgetState extends State<InputAnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: constraint.maxWidth * 0.85,
        child: TextField(
          enabled: widget.isEnable,
          controller: widget.inputController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
              suffixIcon: widget.inputController.text.length > 0
                  ? IconButton(
                      onPressed: () {
                        widget.inputController.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.cancel, color: Colors.grey))
                  : null,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: widget.placeHolder,
              focusColor: Colors.white,
              fillColor: Colors.white70),
        ),
      );
    });
  }
}
 
        // TextField(
        //     cursorColor: Colors.blue,
        //     decoration: InputDecoration(labelText: "Sua Resposta"),
        //     keyboardType: TextInputType.text,
        //     controller: inputController),