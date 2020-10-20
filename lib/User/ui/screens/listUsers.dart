import 'dart:async';
import 'package:camera/camera.dart';
import 'package:covid/Prediagnostico/ui/screens/formPrediagnostico.dart';
import 'package:covid/User/ui/screens/ediUser.dart';
import 'package:covid/User/ui/screens/registerUser.dart';
import 'package:covid/chart.dart';
import 'package:covid/services/database_helper.dart';
import 'package:covid/widgets/btn_next.dart';
import 'package:covid/widgets/floating_action_button_green.dart';
import 'package:covid/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wakelock/wakelock.dart';
import 'package:covid/widgets/widget_view_politica.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class ListUsers extends StatefulWidget {
  @override
  ListUserView createState() {
    return ListUserView();
  }
}

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, idUser) async {
  var db = new DatabaseHelper();
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmación'),
        content: const Text('¿Estas seguro que desea eliminar este usuario?.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CERRAR'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('ACEPTAR'),
            onPressed: () async {
              await db.deleteUser(idUser);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ListUsers()));
            },
          )
        ],
      );
    },
  );
}

class ListUserView extends State<ListUsers> {
  double iconSize = 40;
  var db = new DatabaseHelper();
  var dataRsp = [];
  var listTableRow = new List();

  ListUserView() {
    db.getUsers().then((values) {
      setState(() {
        dataRsp = values;
      });
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    // List<TableRow> listTableRow = new List();
    // TODO: implement build;
    final content = Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Column(children: [
            Text(
              'Nombre',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0),
            )
          ]),
          Column(children: [
            Text('Apellido',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0))
          ]),
          Column(children: [
            Text('Acciones',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0))
          ]),
        ]),
        for (var d in dataRsp)
          TableRow(children: [
            Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 15.0),
              //alignment: Alignment(0.0, 5.5),
              child: Text(
                this.capitalize(d['firstName'].toString()),
                textAlign: TextAlign.center,
                //  textDirection: TextDirection.ltr,
              ),
            ),

            Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 15.0),
              //alignment: Alignment(0.0, 5.5),
              child: Text(
                this.capitalize(d['lastName'].toString()),
                textAlign: TextAlign.center,
                //  textDirection: TextDirection.ltr,
              ),
            ),

            Container(
                //width: 10.0,

                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: MaterialButton(
                      minWidth: 20.0,
                      //color: Color(0xFF801E48),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditUser(idUser: d['id'])));
                      },
                      child: Icon(Icons.edit)),
                ),
                if (d['principal'] == 0)
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: MaterialButton(
                        minWidth: 20.0,
                        //color: Color(0xFF801E48),
                        onPressed: () {
                          _asyncConfirmDialog(context, d['id']);
                        },
                        child: Icon(Icons.delete)),
                  ),
              ],
            ))
            // Text(d['rowid'].toString())),
          ])
      ],
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Usuarios'),
          backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        drawer: MenuLateral('usuarios'),
        body: SingleChildScrollView(child: Container(margin: EdgeInsets.all(10), child: content)),
        floatingActionButton: FloatingActionButtonGreen(
            iconData: Icons.add,
            txt: 'Crear un usuario',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WidgetViewPolitica(flagRoute: false)));
              /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterUser())); */
            }));
  }
}
