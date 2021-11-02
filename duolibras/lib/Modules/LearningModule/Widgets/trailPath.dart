import 'package:flutter/material.dart';
import 'dart:ui' as ui;

enum _Position { Left, Right }

class TrailPath extends CustomPainter {
  Path mainPath;
  AnimationController _animationController;
  Map<Color, int> colorForRows;
  int index;
  var lastPosition = _Position.Left;

  int get maxLevelProgress {
    return mainPath.computeMetrics().length;
  }

  TrailPath(
      this.mainPath, this._animationController, this.colorForRows, this.index)
      : super(repaint: _animationController);

  @override
  void paint(Canvas canvas, Size size) {
    if (colorForRows.length <= 0) {
      return;
    }

    Paint paint = Paint()
      ..color = colorForRows.entries.elementAt(0).key
      ..style = PaintingStyle.fill
      ..strokeWidth = 8.0;

    var initialPosition = 00.0;

    canvas.drawCircle(Offset(size.width * 0.3, initialPosition), 9, paint);

    lastPosition = _Position.Left;
    for (var i = 0; i < colorForRows.entries.length; i++) {
      paint.style = PaintingStyle.stroke;
      paint.color = colorForRows.entries.elementAt(i).key;
      final numberOfRows = colorForRows.entries.elementAt(i).value;

      // if (i + 1 != colorForRows.entries.length) {
      //   final pathLine =
      //       createNewModuleLine(initialPosition, size, lastPosition, canvas, [
      //     colorForRows.entries.elementAt(i).key,
      //     colorForRows.entries.elementAt(i + 1).key,
      //   ])

      initialPosition = drawPathLines(
          lastPosition, initialPosition, numberOfRows, canvas, paint, size);

      if (i + 1 != colorForRows.entries.length) {
        final _ =
            createNewModuleLine(initialPosition, size, lastPosition, canvas, [
          colorForRows.entries.elementAt(i).key,
          colorForRows.entries.elementAt(i + 1).key,
        ]);
        // mainPath.addPath(pathLine, const Offset(0, 0));
        // mainPath.extendWithPath(pathLine, const Offset(0, 0));
      }
    }

    Paint paintball = Paint();
    paintball.color = colorForRows.entries.last.key;
    paintball.strokeWidth = 8.0;
    paintball.style = PaintingStyle.fill;

    if (lastPosition != _Position.Right) {
      canvas.drawCircle(
          Offset((size.width * 0.7) - (size.width * 0.4), initialPosition),
          9,
          paintball);
    } else {
      canvas.drawCircle(
          Offset((size.width * 0.3) + (size.width * 0.4), initialPosition),
          9,
          paintball);
    }

    paintball.color = Colors.amber;
    canvas.drawCircle(
        ui.Offset(calculate(_animationController.value, index).dx,
            calculate(_animationController.value, index).dy),
        12.0,
        paintball);
  }

  double drawPathLines(_Position initialPosition, double initialHeight,
      int numberOfModules, Canvas canvas, Paint paint, Size size) {
    var shouldDrawLine = true;
    Path tempPath = Path();
    for (var i = 1; i <= numberOfModules; i++) {
      shouldDrawLine = true; //i != numberOfModules;
      if (initialPosition == _Position.Right) {
        Path p = createRightCurve(initialHeight, size, shouldDrawLine);
        // mainPath.addPath(p, const Offset(0, 0));
        tempPath.addPath(p, const Offset(0, 0));
        lastPosition = _Position.Left;
      } else {
        Path p = createLeftCurve(initialHeight, size, shouldDrawLine);
        // mainPath.addPath(p, const Offset(0, 0));
        tempPath.addPath(p, const Offset(0, 0));

        lastPosition = _Position.Right;
      }
      initialPosition =
          initialPosition == _Position.Right ? _Position.Left : _Position.Right;
      initialHeight += 200;
    }
    mainPath.addPath(tempPath, const Offset(0, 0));
    canvas.drawPath(tempPath, paint);

    // mainPath.extendWithPath(tempPath, const Offset(0, 0));
    // if (isTheLast) {
    //   Path finalBall = Path();
    //   finalBall.moveTo(x, initialHeight - 200);
    // }

    return initialHeight;
  }

  Path createLeftCurve(double initialHeight, Size size, bool drawLine) {
    Path path = Path();
    path.moveTo(size.width * 0.3, initialHeight); //300

    path.cubicTo(0, initialHeight - 5, 0, initialHeight + 205, size.width * 0.3,
        initialHeight + 200);

    if (drawLine) {
      Path pathLine = Path();
      pathLine.moveTo(size.width * 0.3, initialHeight + 200);
      pathLine.relativeLineTo(size.width * 0.4, 0);
      path.extendWithPath(pathLine, const Offset(0, 0));
    }
    // mainPath.extendWithPath(path, const Offset(0, 0));
    // mainPath.addPath(path, const Offset(0, 0));
    return path;
  }

  Path createRightCurve(double initialHeight, Size size, bool drawLine) {
    Path path = Path();
    path.moveTo(size.width * 0.7, initialHeight); //300

    path.cubicTo(size.width, initialHeight - 5, size.width, initialHeight + 205,
        size.width * 0.7, initialHeight + 200);

    if (drawLine) {
      Path pathLine = Path();
      pathLine.moveTo(size.width * 0.7, initialHeight + 200);
      pathLine.relativeLineTo(-(size.width * 0.4), 0);

      path.extendWithPath(pathLine, const Offset(0, 0));
    }

    // mainPath.extendWithPath(path, const Offset(0, 0));

    return path;
  }

  Path createNewModuleLine(double initialHeight, Size size, _Position _position,
      Canvas canvas, List<Color> colors) {
    Path pathLine = Path();
    if (_position == _Position.Right) {
      pathLine.moveTo(size.width * 0.7, initialHeight);
      pathLine.lineTo((size.width * 0.3), initialHeight);
    } else {
      pathLine.moveTo(size.width * 0.3, initialHeight);
      pathLine.lineTo(size.width * 0.3, initialHeight);
    }

    final initialOffset = _position == _Position.Right
        ? Offset(size.width * 0.3, initialHeight)
        : Offset(size.width * 0.7, initialHeight);

    final finalOffset = _position == _Position.Right
        ? Offset(size.width * 0.7, initialHeight)
        : Offset(size.width * 0.3, initialHeight);
    Paint linePaint = Paint();
    linePaint.shader = ui.Gradient.linear(
      initialOffset,
      finalOffset,
      colors,
    );
    linePaint.style = PaintingStyle.stroke;
    linePaint.strokeWidth = 8.0;
    canvas.drawPath(pathLine, linePaint);
    // mainPath.addPath(pathLine, const Offset(0, 0));
    // mainPath.extendWithPath(pathLine, const Offset(0, 0));
    return pathLine;
  }

  Offset calculate(value, pathIndex) {
    try {
      ui.PathMetrics pathMetrics = mainPath.computeMetrics();
      ui.PathMetric pathMetric = pathMetrics.elementAt(pathIndex);
      value = pathMetric.length * value;
      ui.Tangent pos = pathMetric.getTangentForOffset(value)!;
      return pos.position;
    } catch (e) {
      return Offset(0, 0);
    }
  }

  Offset calculateLastPosition(value) {
    ui.PathMetrics pathMetrics = mainPath.computeMetrics();

    ui.PathMetric pathMetric = pathMetrics.last;
    value = pathMetric.length * value;
    ui.Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
