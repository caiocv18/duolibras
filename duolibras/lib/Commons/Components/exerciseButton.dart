import 'package:flutter/material.dart';

class ExerciseButton extends StatefulWidget {
  const ExerciseButton(
      {Key? key,
      required this.child,
      required this.size,
      required this.color,
      this.isCircle = false,
      this.duration = const Duration(milliseconds: 160),
      this.onPressed,
      this.backgroundColor = Colors.white})
      : super(key: key);

  final Widget child;
  final Color color;
  final Duration duration;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final bool isCircle;

  final double size;

  @override
  _ExerciseButtonState createState() => _ExerciseButtonState();
}

class _ExerciseButtonState extends State<ExerciseButton>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _pressedAnimation;

  TickerFuture? _downTicker;

  double get buttonDepth =>
      widget.isCircle ? widget.size * 0.03 : widget.size * 0.2;

  void _setupAnimation() {
    _animationController?.stop();
    final oldControllerValue = _animationController?.value ?? 0.0;
    _animationController?.dispose();
    _animationController = AnimationController(
      duration: Duration(microseconds: widget.duration.inMicroseconds ~/ 2),
      vsync: this,
      value: oldControllerValue,
    );
    _pressedAnimation = Tween<double>(begin: -buttonDepth, end: 0.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(ExerciseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _setupAnimation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupAnimation();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (widget.onPressed != null) {
      _downTicker = _animationController?.animateTo(1.0);
    }
  }

  void _onTapUp(_) {
    if (widget.onPressed != null) {
      _downTicker?.whenComplete(() {
        _animationController?.animateTo(0.0);
        widget.onPressed?.call();
      });
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      _animationController?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vertPadding = widget.size * 0.25;
    final horzPadding = widget.isCircle ? vertPadding : widget.size * 0.50;
    final radius = BorderRadius.circular(horzPadding * 1.5);

    return Container(
      padding: widget.onPressed != null
          ? EdgeInsets.only(bottom: 2, left: 0.5, right: 0.5)
          : null,
      decoration: BoxDecoration(
        color: widget.color,

        ///
        borderRadius: radius,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: _pressedAnimation!,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                      offset: Offset(0.0, _pressedAnimation!.value),
                      child: child,
                    );
                  },
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: radius,
                        child: Stack(
                          children: <Widget>[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: widget.backgroundColor,
                                borderRadius: radius,
                              ),
                              child: SizedBox.expand(),
                            ),
                            Transform.translate(
                              offset: Offset(0.0, vertPadding * 2),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: widget.backgroundColor,
                                  borderRadius: radius,
                                ),
                                child: SizedBox.expand(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: vertPadding,
                          horizontal: horzPadding,
                        ),
                        child: widget.child,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _hslRelativeColor({double h = 0.0, s = 0.0, l = 0.0}) {
    final hslColor = HSLColor.fromColor(Colors.white);
    h = (hslColor.hue + h).clamp(0.0, 360.0);
    s = (hslColor.saturation + s).clamp(0.0, 1.0);
    l = (hslColor.lightness + l).clamp(0.0, 1.0);
    return HSLColor.fromAHSL(hslColor.alpha, h, s, l).toColor();
  }
}

// USAGE - Fancy Button

// Simple Text - Non Clickable

// FancyButton(
//     child: Text(
//        "Your Amazing Text",
//        style: Utils.textStyle(18.0),
//        ),
//     size: 18,
//     color: Color(0xFFCA3034),
// ),

// Complex Button - Clickable

// FancyButton(
//     child: Text(
//            "X",
//            textAlign: TextAlign.center,
//            style: TextStyle(
//                color: Colors.white,
//                fontSize: 18,
//                fontFamily: 'Gameplay',
//            ),
//      ),
//      size: 25,
//      color: Color(0xFFCA3034),
//      onPressed: () {
//         Navigator.of(context).pop();
//      },
// ),