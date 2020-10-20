import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final TextEditingController controller;
  int MaxLines = 1;
  ValueChanged<String> onchanged;
  bool readOnly;
  bool lettersOnly;

  TextInput(
      {Key key,
      @required this.hintText,
      @required this.inputType,
      @required this.controller,
      this.MaxLines,
      this.readOnly,
      this.lettersOnly,
      this.onchanged});

  @override
  Widget build(BuildContext context) {
    /* print('readOnly -----');
    print(readOnly);
    print('readOnly -----');
    return Text('hola'); */
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        inputFormatters: ((lettersOnly == null || lettersOnly == false)
            ? []
            : [
                new FilteringTextInputFormatter.allow(
                    RegExp("[A-Za-zÁÉÍÓÚáéíóúñÑ ]")),
              ]),
        onChanged: onchanged,
        controller: controller,
        keyboardType: inputType,
        maxLines: MaxLines,
        readOnly: ((readOnly == null || readOnly == false) ? false : true),
        style: TextStyle(
            //backgroundColor: Colors.amber,
            fontSize: 15.0,
            fontFamily: 'Lato',
            color: ((readOnly == null || readOnly == false)
                ? Colors.blueGrey
                : Colors.blueGrey[400]),
            //color: Colors.blueGrey[400],
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            filled: true,
            fillColor: ((readOnly == null || readOnly == false)
                ? Color(0xFFe5e5e5)
                : Color(0xFFAEAEAE)),
            //fillColor: Color(0xFFe5e5e5),
            border: InputBorder.none,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                borderRadius: BorderRadius.all(Radius.circular(9.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                borderRadius: BorderRadius.all(Radius.circular(9.0)))),
      ),
    );
  }
}
