import 'dart:async';

import 'package:flutter/material.dart';

class BlinkWidget extends StatefulWidget {
  final List<Widget> children;
  final int interval;
  final int timer;
  BlinkWidget(
      {@required this.children, this.interval = 800, Key key, this.timer})
      : super(key: key);

  @override
  _BlinkWidgetState createState() => _BlinkWidgetState();
}

class _BlinkWidgetState extends State<BlinkWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int _currentWidget = 0;
  Timer _timer;
  int _start;

  @override
  void initState() {
    super.initState();
    _start = widget.timer;
    _controller = new AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (++_currentWidget == widget.children.length) {
            _currentWidget = 0;
          }
        });

        _controller.forward(from: 0.0);
      }
    });
    _controller.forward();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Grabando ", style: TextStyle(color: Colors.red)),
                widget.children[_currentWidget],
              ],
            ),
            Text(
              "Tiempo restante: $_start segundos",
              style: TextStyle(height: 2.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
