import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController inputController;
  final String hintText;
  final bool isEnabled;
  final Function(String) _onSubmitHandler;

  CustomTextfield(this.inputController, this.hintText, this.isEnabled,
      this._onSubmitHandler);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final focusNode = FocusNode();
  var isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Container(
        width: constraint.maxWidth,
        child: TextField(
          style: TextStyle(fontSize: 23, fontFamily: "Nunito", fontWeight: FontWeight.w500),
          readOnly: !isEditing,
          focusNode: focusNode,
          autofocus: false,
          textAlign: TextAlign.center,
          controller: widget.inputController,
          onSubmitted: (_) => setState(() {
            isEditing = false;
            widget._onSubmitHandler(widget.inputController.text);
          }),
          decoration: InputDecoration(
              suffixIcon: isEditing
              ? IconButton(
                  onPressed: () {
                    widget.inputController.clear();
                    setState(() {
                      isEditing = false;
                      FocusScope.of(context).unfocus();
                    });
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
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              hintText: !isEditing ? widget.hintText : "",
              hintStyle: TextStyle(color: Colors.grey[800]),
              fillColor: Colors.white
          ),
        ),
      );
    });
  }

    // to open keyboard call this function;
  void openKeyboard() {
    FocusScope.of(context).requestFocus(focusNode);
  }

}
