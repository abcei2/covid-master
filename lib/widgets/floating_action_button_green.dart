import 'package:flutter/material.dart';

class FloatingActionButtonGreen extends StatefulWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  String txt;

  FloatingActionButtonGreen(
      {Key key, @required this.iconData, @required this.onPressed, this.txt});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FloatingActionButtonGreen();
  }
}

class _FloatingActionButtonGreen extends State<FloatingActionButtonGreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton.extended(
      backgroundColor: Color(0xFF11DA53),
      tooltip: widget.txt,
      icon: Icon(widget.iconData),
      onPressed: widget.onPressed,
      label: Text(widget.txt),
      heroTag: null,
    );
  }
}
