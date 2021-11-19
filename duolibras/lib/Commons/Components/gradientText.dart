import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: AutoSizeText(text,
          minFontSize: (style?.fontSize ?? 20) - 3,
          maxFontSize: style?.fontSize ?? 20,
          maxLines: 1,
          style: style),
    );
  }
}
