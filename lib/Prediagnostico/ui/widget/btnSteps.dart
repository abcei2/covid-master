import 'package:covid/widgets/slider.dart';
import 'package:flutter/material.dart';

class BtnSteps extends StatefulWidget {
  double height = 0.0;
  double width = 0.0;
  final VoidCallback onPressedBack;
  final VoidCallback onPressedForward;
  final Map dataQuestion;
  final bool flag;

  List<Widget> list = new List<Widget>();
  bool rsp1 = false;
  bool rsp2 = false;
  BtnSteps(
      {Key key,
      @required this.flag,
      this.onPressedBack,
      this.onPressedForward,
      this.dataQuestion,
      this.height,
      this.width}) {}

  @override
  _BtnSteps createState() => _BtnSteps();
}

class _BtnSteps extends State<BtnSteps> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var content;
    if (widget.flag == true) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // const SizedBox(height: 30),
          RaisedButton(
            onPressed: widget.onPressedForward,
            child: Icon(Icons.arrow_forward_ios),
          ),
          //const SizedBox(height: 30),
        ],
      );
    } else {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: widget.onPressedBack,
            child: Icon(Icons.arrow_back_ios),
          ),
          // const SizedBox(height: 30),
          RaisedButton(
            padding: (widget.dataQuestion['id'] == 27) ? EdgeInsets.all(10) : null,
            color: (widget.dataQuestion['id'] == 27) ? Colors.blue : null,
            onPressed: widget.onPressedForward,
            child: ((widget.dataQuestion['id'] == 27)
                ? Text('Analizar\ndatos',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center)
                : Icon(Icons.arrow_forward_ios)),
          ),
          //const SizedBox(height: 30),
        ],
      );
    }

    final btn = Center(child: Container(child: content));

    return Container(
        alignment: Alignment.bottomCenter,
        margin:
            EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 20.0),
        height: widget.height,
        width: (screenWidth - 60),
        child: btn);
  }
}
