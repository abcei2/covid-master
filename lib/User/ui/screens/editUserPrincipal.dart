import 'dart:io';
import 'package:covid/Prediagnostico/ui/screens/homePrediagnostico.dart';
import 'package:covid/homePage.dart';
import 'package:covid/models/User.dart';
import 'package:covid/services/database_helper.dart';
import 'package:covid/widgets/button_purple.dart';
import 'package:covid/widgets/date_input.dart';
import 'package:covid/widgets/menu_lateral.dart';
import 'package:covid/widgets/permissions_alerts.dart';
import 'package:covid/widgets/select_input.dart';
import 'package:covid/widgets/text_input.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditUserPrincipal extends StatefulWidget {
  File image;
  double screenWidth;

  EditUserPrincipal({Key key});

  @override
  State createState() {
    print('contructor EditUserPrincipal');
    return _EditUserPrincipal();
  }
}

class _EditUserPrincipal extends State<EditUserPrincipal> {
  final _controllerNameUser = TextEditingController();
  final _controllerLastNameUser = TextEditingController();
  final _controllerEmailUser = TextEditingController();
  final _controllerPhoneUser = TextEditingController();
  final _controllerNumberIdentification = TextEditingController();
  final _controllerBirthDay = TextEditingController();
  Position _currentPosition;
  var name;
  var lastName;
  var email;
  var phone;
  User userData;
  String _currentGenero;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _EditUserPrincipal() {
    var db = new DatabaseHelper();
    db.getUser(1).then((value) {
      setState(() {
        this.userData = value;
        _controllerNameUser.text = value.firstName;
        _controllerLastNameUser.text = value.lastName;
        _controllerEmailUser.text = value.email;
        _controllerPhoneUser.text = value.phone;
        _controllerNumberIdentification.text = value.numberIdentification;
        _controllerBirthDay.text = value.birthDay;
        _currentGenero = value.genero;
      });
      /* Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage())); */
    });
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _getCurrentLocation();
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(value: '1', child: new Text('Masculino')));
    items.add(new DropdownMenuItem(value: '2', child: new Text('Femenino')));
    //items.add(new DropdownMenuItem(value: '3', child: new Text('Otro')));
    return items;
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _onAlertButtonPressed(context, msg) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Información",
      desc: msg,
      buttons: [
        DialogButton(
          child: Text(
            "Cerrar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // onPressed: () => Navigator.pop(context, false),
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Mi perfil"),
          backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        drawer: MenuLateral('perfil'),
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: TextInput(
                    controller: _controllerNameUser,
                    lettersOnly: true,
                    hintText: 'Nombre',
                    inputType: null,
                    MaxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: TextInput(
                    controller: _controllerLastNameUser,
                    hintText: 'Apellido',
                    lettersOnly: true,
                    inputType: null,
                    MaxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: TextInput(
                    readOnly: true,
                    controller: _controllerNumberIdentification,
                    hintText: 'Número de identificación',
                    inputType: TextInputType.phone,
                    MaxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: SelectInput(
                      hintText: 'Sexo',
                      value: _currentGenero,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: TextInput(
                    controller: _controllerEmailUser,
                    hintText: 'Correo',
                    inputType: TextInputType.emailAddress,
                    MaxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: DateInput(
                    controller: _controllerBirthDay,
                    hintText: 'Fecha de nacimiento',
                    inputType: TextInputType.datetime,
                    MaxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: TextInput(
                    controller: _controllerPhoneUser,
                    hintText: 'Celular',
                    inputType: TextInputType.phone,
                    MaxLines: 1,
                  ),
                ),
                Container(
                  width: 70.0,
                  child: ButtonPurple(
                    buttonText: 'Guardar',
                    onPressed: () async {
                      if (_controllerNameUser.text == '' ||
                          _controllerNameUser.text == null) {
                        _onAlertButtonPressed(
                            context, 'El campo nombre es requerido.');
                        return;
                      }

                      if (_controllerLastNameUser.text == '' ||
                          _controllerLastNameUser.text == null) {
                        _onAlertButtonPressed(
                            context, 'El campo apellido es requerido.');
                        return;
                      }

                      if (_controllerNumberIdentification.text == '' ||
                          _controllerNumberIdentification.text == null) {
                        _onAlertButtonPressed(context,
                            'El número de identificación es requerido.');
                        return;
                      }

                      if (this._currentGenero == null) {
                        _onAlertButtonPressed(
                            context, 'El campo sexo es requerido.');
                        return;
                      }

                      if (_controllerEmailUser.text == '' ||
                          _controllerEmailUser.text == null) {
                        _onAlertButtonPressed(context,
                            'El campo correo electrónico es requerido.');
                        return;
                      }

                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_controllerEmailUser.text);

                      if (emailValid == false) {
                        _onAlertButtonPressed(context,
                            'El formato del correo electrónico no es valido.');
                        return;
                      }

                      if (_controllerBirthDay.text == '' ||
                          _controllerBirthDay.text == null) {
                        _onAlertButtonPressed(context,
                            'El campo fecha de nacimiento es requerido.');
                        return;
                      }

                      if (_controllerPhoneUser.text == '' ||
                          _controllerPhoneUser.text == null) {
                        _onAlertButtonPressed(
                            context, 'El campo celular es requerido.');
                        return;
                      }

                      var deviceid = await DeviceId.getID;
                      var db = new DatabaseHelper();
                      //print(_currentPosition.latitude);
                      bool hasLocation = _currentPosition != null;
                      String latitude = hasLocation
                          ? _currentPosition.latitude.toString()
                          : '0';
                      String longitude = hasLocation
                          ? _currentPosition.longitude.toString()
                          : '0';
                      if (!hasLocation) {
                        await noLocationAlert(context);
                      }
                      User item = User(
                          birthDay: _controllerBirthDay.text,
                          genero: this._currentGenero,
                          id: 1,
                          principal: 1,
                          syncData: this.userData.syncData,
                          firstName: _controllerNameUser.text,
                          lastName: _controllerLastNameUser.text,
                          email: _controllerEmailUser.text,
                          phone: _controllerPhoneUser.text,
                          numberIdentification:
                              _controllerNumberIdentification.text,
                          latitude: latitude,
                          longitude: longitude);

                      await db.update(item);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HomePrediagnostico()));
                    },
                  ),
                )
              ],
            ),
          )
        ]));
  }

  void changedDropDownItem(dynamic selectedGenero) {
    print("--");
    print(selectedGenero);
    setState(() {
      _currentGenero = selectedGenero;
    });
  }
}
