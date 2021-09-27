import 'package:flutter/material.dart';

class Midiawidget extends StatelessWidget {
  final String midiaURL;

  const Midiawidget(this.midiaURL);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(200, 205, 219, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.93,
          heightFactor: 0.93,
          child: Container(
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              midiaURL,
              fit: BoxFit.fill,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}
