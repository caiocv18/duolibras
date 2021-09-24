import 'package:flutter/material.dart';

class ImageChoiceItem extends StatelessWidget {
  final String _imageUrl;
  Function _handleQuestion;

  ImageChoiceItem(this._imageUrl, this._handleQuestion);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _handleQuestion(_imageUrl);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Image.network(_imageUrl),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(0.65), Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
