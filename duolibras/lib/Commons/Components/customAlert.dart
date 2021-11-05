import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:flutter/material.dart';

class CustomAlert extends StatefulWidget {
  final String title;
  final String? yesTitle;
  final String? noTitle;
  final Function? yesButton;
  final Function? noButton;
  CustomAlert(
      {required this.title,
      required this.yesTitle,
      required this.noTitle,
      required this.yesButton,
      required this.noButton});

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      backgroundColor: Colors.white,
      child: LayoutBuilder(builder: (ctx, constraint) {
        return Container(
          height: 250,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  width: 250,
                  child: Text(widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 18)),
                ),
                SizedBox(height: 10),
                if (widget.yesTitle != null) _buildYesButton(constraint),
                if (widget.noTitle != null) _buildNoButton(constraint)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildYesButton(BoxConstraints constraint) {
    return Column(
      children: [
        Container(
            height: 2, width: constraint.maxWidth, color: Colors.grey[300]),
        Container(
          width: 170,
          height: 53,
          child: TextButton(
              child: Text(widget.yesTitle ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w800,
                      color: HexColor.fromHex('E97070'),
                      fontSize: 18)),
              onPressed: () {
                if (widget.yesButton != null) widget.yesButton!();
              }),
        ),
      ],
    );
  }

  Widget _buildNoButton(BoxConstraints constraint) {
    return Column(
      children: [
        Container(
            height: 2, width: constraint.maxWidth, color: Colors.grey[300]),
        Container(
            width: 170,
            height: 53,
            child: TextButton(
                child: Text(widget.noTitle ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 18)),
                onPressed: () {
                  if (widget.noButton != null) widget.noButton!();
                }))
      ],
    );
  }
}
