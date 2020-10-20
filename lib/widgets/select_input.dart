import 'package:flutter/material.dart';

class SelectInput extends StatelessWidget {
  final String hintText;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged onChanged;

  SelectInput(
      {Key key,
      @required this.hintText,
      @required this.value,
      @required this.items,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 55, //gives the height of the dropdown button
        width: MediaQuery.of(context)
            .size
            .width, //gives the width of the dropdown button
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0xFFe5e5e5)),
        // padding: const EdgeInsets.symmetric(horizontal: 13), //you can include padding to control the menu items
        child: Theme(
            data: Theme.of(context).copyWith(
                // background color for the dropdown items
                buttonTheme: ButtonTheme.of(context).copyWith(
              alignedDropdown:
                  true, //If false (the default), then the dropdown's menu will be wider than its button.
            )),
            child: DropdownButtonHideUnderline(
              // to hide the default underline of the dropdown button
              child: DropdownButton<String>(
                iconEnabledColor:
                    Color(0xFF595959), // icon color of the dropdown button
                items: items,
                hint: Text(
                  hintText,
                  style: TextStyle(
                      color: Color(0xFF595959), fontWeight: FontWeight.bold),
                ), // setting hint
                onChanged: onChanged,
                value: value, // displaying the selected value
              ),
            )),
      ),
    );
    /*    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          color: Color(0xFFe5e5e5),
        ),
        child: DropdownButton(
          hint: Text(hintText),
          isExpanded: true,
          value: value,
          items: items,
          onChanged: onChanged,
          style: TextStyle(            
              fontSize: 15.0,
              fontFamily: 'Lato',
              color: Colors.blueGrey,              
              fontWeight: FontWeight.bold),
        )); */
  }
}
