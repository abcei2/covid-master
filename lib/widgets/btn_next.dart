import 'package:covid/widgets/button_purple.dart';
import 'package:flutter/material.dart';

class BtnNext extends StatelessWidget {
  final bool _flag;

  BtnNext(this._flag);

  @override
  Widget build(BuildContext context) {
    if (this._flag == true) {
      return new ListView(children: <Widget>[
        Container(
            child: Center(
          child: Text(
            "Se ha tomado la lectura del ritmo cardiaco.",
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
          ),
        )),
        Container(
          width: 500.0,
          child: ButtonPurple(
            buttonText: 'Siguiente',
            onPressed: () async {
              print("NEXT");
            },
          ),
        )
      ]);
      //return new
    } else {
      return new Container(
        width: 500.0,
      );
    }
  }
}
