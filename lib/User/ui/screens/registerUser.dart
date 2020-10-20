import 'dart:io';
import 'package:covid/User/ui/screens/listUsers.dart';
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
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:geolocator/geolocator.dart' as g;

class RegisterUser extends StatefulWidget {
  File image;

  @override
  _RegisterUser createState() => _RegisterUser();
}

class _RegisterUser extends State<RegisterUser> {
  final _controllerNameUser = TextEditingController();
  final _controllerLastNameUser = TextEditingController();
  final _controllerGenero = TextEditingController();
  final _controllerEmailUser = TextEditingController();
  final _controllerPhoneUser = TextEditingController();
  final _controllerNumberIdentification = TextEditingController();
  final _controllerBirthDay = TextEditingController();
  Position _currentPosition;
  var name;
  var typeIdentification;
  var numberIdentification;
  var db = new DatabaseHelper();
  String _currentGenero;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  final LocalStorage storage = new LocalStorage('covid_u');

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String fullName;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    this.typeIdentification = 'Cédula de ciudadanía';
    fullName = storage.getItem('nameTmp');
    _controllerNumberIdentification.text = storage.getItem('numberTmp');
    super.initState();
    _setName();
    _activateGps();
  }

  _setName() {
    List<String> words = fullName.split(" ");
    switch (words.length) {
      case 1:
        _controllerNameUser.text = words[0];
        break;
      case 2:
        _controllerNameUser.text = words[0];
        _controllerLastNameUser.text = words[1];
        break;
      case 3:
        _controllerNameUser.text = words[0];
        _controllerLastNameUser.text = words[1] + " " + words[2];
        break;
      default:
        String lastName = "";
        _controllerNameUser.text = words[0] + " " + words[1];
        words.removeAt(0);
        words.removeAt(0);
        words.forEach((element) {
          lastName = lastName + element + " ";
        });
        _controllerLastNameUser.text = lastName;
        break;
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(value: '1', child: new Text('Masculino')));
    items.add(new DropdownMenuItem(value: '2', child: new Text('Femenino')));
    //items.add(new DropdownMenuItem(value: '3', child: new Text('Otro')));
    return items;
  }

  _activateGps() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    //_getCurrentLocation();
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _getCurrentLocation();
      }
    } else {
      _getCurrentLocation();
    }
    _locationData = await location.getLocation();
  }

  _RegisterUser() {
    //  _getCurrentLocation();
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: g.LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crear usuario"),
          backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
          automaticallyImplyLeading: true,
          /*leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )*/
        ),
        //drawer: MenuLateral('usuarios'),
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
                    /*          onchanged: (String newValue) {
                      setState(() {
                        this.name =
                            newValue + ' ' + _controllerLastNameUser.text;
                      });
                    }, */
                    onchanged: (String newValue) {
                      setState(() {
                        this.name =
                            newValue + ' ' + _controllerLastNameUser.text;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: TextInput(
                    controller: _controllerLastNameUser,
                    lettersOnly: true,
                    hintText: 'Apellido',
                    inputType: null,
                    MaxLines: 1,
                    onchanged: (String newValue) {
                      setState(() {
                        this.name = _controllerNameUser.text + ' ' + newValue;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: TextInput(
                    controller: _controllerNumberIdentification,
                    hintText: 'Número de identificación',
                    inputType: TextInputType.phone,
                    MaxLines: 1,
                    onchanged: (newValue) {
                      setState(() {
                        this.numberIdentification = newValue.toString();
                        //_controllerNumberIdentification.text;
                      });
                    },
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

                      DateTime moonLanding =
                          DateTime.parse(_controllerBirthDay.text);
                      //print(moonLanding.month);
                      var age = calculateAge(moonLanding);
                      if (age < 18) {
                        _onAlertButtonPressed(context,
                            'Debes ser mayor de edad para hacer uso de la plataforma.');
                        return;
                      }
                      var deviceid = await DeviceId.getID;
                      var db = new DatabaseHelper();
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
                          syncData: 0,
                          deviceId: deviceid,
                          firstName: _controllerNameUser.text,
                          lastName: _controllerLastNameUser.text,
                          email: _controllerEmailUser.text,
                          phone: _controllerPhoneUser.text,
                          numberIdentification:
                              _controllerNumberIdentification.text,
                          principal: 0,
                          latitude: latitude,
                          longitude: longitude);

                      await db.saveUser(item);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ListUsers()));
                    },
                  ),
                )
              ],
            ),
          )
        ]));
  }

  calculateAge(DateTime date) {
    var today = new DateTime.now();
    print(today);
    var age = today.year - date.year;
    var month = today.month - date.month;
    if (month < 0 || (month == 0 && today.day < date.day)) {
      age--;
    }
    return age;
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

  void changedDropDownItem(dynamic selectedGenero) {
    print("--");
    print(selectedGenero);
    setState(() {
      _currentGenero = selectedGenero;
    });
  }
}
