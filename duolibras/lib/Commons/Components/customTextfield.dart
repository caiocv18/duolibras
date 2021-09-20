import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isEnabled;
  final Function(String) _onSubmitHandle;
  final focusNode = FocusNode();

  CustomTextfield(
      this.controller, this.hintText, this.isEnabled, this._onSubmitHandle);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Flexible(
                  child: TextField(
                focusNode: focusNode,
                enabled: isEnabled,
                onSubmitted: _onSubmitHandle,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )),
              if (isEnabled)
                TextButton(
                  onPressed: () =>
                      {FocusScope.of(context).requestFocus(focusNode)},
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.edit),
                    ],
                  ),
                ),
            ],
          ),
        ));
  }
}
