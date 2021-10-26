import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController inputController;
  final String hintText;
  final bool isEnabled;
  final Function(String) _onSubmitHandle;

  CustomTextfield(this.inputController, this.hintText, this.isEnabled,
      this._onSubmitHandle);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final focusNode = FocusNode();
  var isEditing = false;

  // to open keyboard call this function;
  void openKeyboard() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.inputController.text = widget.hintText;

    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: constraint.maxWidth,
        child: TextField(
          focusNode: focusNode,
          autofocus: false,
          textAlign: TextAlign.center,
          controller: widget.inputController,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => setState(() {
            isEditing = false;
          }),
          decoration: InputDecoration(
              suffixIcon: isEditing
                  ? IconButton(
                      onPressed: () {
                        widget.inputController.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.cancel, color: Colors.grey))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          openKeyboard();
                          isEditing = true;
                        });
                      },
                      icon: Image.asset(Constants.imageAssets.edit_button),
                    ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[800]),
              fillColor: Colors.white),
        ),
      );
    });
  }
}
