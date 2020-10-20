import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final TextEditingController controller;
  int MaxLines = 1;

  DateInput(
      {Key key,
      @required this.hintText,
      @required this.inputType,
      @required this.controller,
      this.MaxLines});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");

    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: DateTimeField(

        controller: controller,
        style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Lato',
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFe5e5e5),
            border: InputBorder.none,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                borderRadius: BorderRadius.all(Radius.circular(9.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                borderRadius: BorderRadius.all(Radius.circular(9.0)))),
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              locale : const Locale("es","ES"),
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime.now());
        },
      ),

      /*  DateTimeField(
        enabled: true,
        controller: controller,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        format: null,
      ), */
    );
  }
}
