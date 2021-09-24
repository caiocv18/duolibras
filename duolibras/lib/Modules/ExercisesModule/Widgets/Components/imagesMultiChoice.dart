import 'package:duolibras/Modules/ExercisesModule/Widgets/Components/imageChoiceItem.dart';
import 'package:flutter/material.dart';

class ImagesMultiChoice extends StatelessWidget {
  final List<String> _answersUrl;
  Function _handleQuestion;

  ImagesMultiChoice(this._answersUrl, this._handleQuestion);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
          padding: EdgeInsets.all(25),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children: [
            ..._answersUrl.map((imageUrl) {
              return ImageChoiceItem(imageUrl, _handleQuestion);
            }).toList()
          ]),
    );
  }
}
