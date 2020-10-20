import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class RadioSet extends StatefulWidget {
  var data;
  List<String> questions;

  RadioSet(this.data) {
    this.questions = this.data['values'];
  }

  @override
  _RadioSetState createState() => _RadioSetState();
}

class _RadioSetState extends State<RadioSet> {
  int groupValue = -1;
  List<Widget> list = new List<Widget>();
  final LocalStorage storage = new LocalStorage('covid_u');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(widget.questions.length, (int i) {
        return Container(
          child: Row(
            children: <Widget>[
              Radio<int>(
                value: i,
                groupValue: storage.getItem('rsp_${widget.data["id"]}'),
                onChanged: _handleRadioValueChange,
              ),
              Text(widget.questions[i])
            ],
          ),
        );
      }),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      storage.setItem('rsp', widget.questions[value]);
      storage.setItem('rsp_${widget.data["id"]}', value);
      groupValue = value;
    });
  }
}
