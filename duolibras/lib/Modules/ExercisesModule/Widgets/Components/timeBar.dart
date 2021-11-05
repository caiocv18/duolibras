import 'dart:async';

import 'package:flutter/material.dart';

class TimerHandler {
  final Duration duration;
  late Function callback;
  Timer? _timer;

  TimerHandler(this.duration);

  void setCallback(Function(Timer) callback) {
    _timer = new Timer.periodic(duration, callback);
  }

  void cancelTimer() {
    if (_timer != null) _timer!.cancel();
  }
}

class TimeBar extends StatefulWidget {
  final Size size;
  final double _totalTime;
  final List<Color> _colors;
  final TimerHandler _timer;
  Function completion;

  TimeBar(
      this.size, this._totalTime, this._colors, this._timer, this.completion) {}

  @override
  State<TimeBar> createState() => _TimeBarState();
}

class _TimeBarState extends State<TimeBar> {
  var _currentTime = 0.0;

  @override
  void initState() {
    _startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decreaseBarParts = widget.size.width / widget._totalTime;
    final availableTime =
        _currentTime < widget._totalTime ? _currentTime : widget._totalTime - 1;
    final barSize = widget.size.width - (decreaseBarParts * availableTime);

    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: barSize,
        height: widget.size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget._colors),
            borderRadius: BorderRadius.all(Radius.circular(20.0))));
  }

  void _startTimer() {
    widget._timer.setCallback((timer) => {
          if (_currentTime == widget._totalTime)
            {
              setState(() {
                timer.cancel();
                widget.completion();
              })
            }
          else
            {
              setState(() {
                _currentTime++;
              })
            }
        });
  }

  @override
  void dispose() {
    widget._timer.cancelTimer();

    super.dispose();
  }
}
