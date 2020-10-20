import 'dart:async';
import 'package:covid/Prediagnostico/ui/screens/formPrediagnostico.dart';
import 'package:covid/services/database_helper.dart';
import 'package:covid/widgets/floating_action_button_green.dart';
import 'package:covid/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class HomePrediagnostico extends StatefulWidget {
  @override
  HomePrediagnosticoView createState() {
    return HomePrediagnosticoView();
  }
}

class HomePrediagnosticoView extends State<HomePrediagnostico> {
  double iconSize = 40;
  var dataRsp = [];
  var db = new DatabaseHelper();
  final LocalStorage storage = new LocalStorage('covid_u');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePrediagnosticoView() {
    storage.deleteItem('numberTmp');
    storage.deleteItem('nameTmp');
    storage.deleteItem('flagNotAccepted');
    storage.setItem('flagAccepted', false);
    db.getResults().then((values) {
      setState(() {
        dataRsp = values;
      });
    });
  }

  formatDate(String dateStr) {
    var p = DateTime.parse(dateStr);
//    var day = p.hour - 5;
    return p.year.toString() +
        '-' +
        ((p.month < 10) ? '0' + p.month.toString() : p.month.toString()) +
        '-' +
        ((p.day < 10) ? '0' + p.day.toString() : p.day.toString()) +
        ' ' +
        //day.toString() +
        ((p.hour < 10) ? '0' + p.hour.toString() : p.hour.toString()) +
        // ((p.hour.toString() - 5) ? : ) +
        ':' +
        ((p.minute < 10) ? '0' + p.minute.toString() : p.minute.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final content =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(
        margin: EdgeInsets.all(10),
        child: Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Text(
                'Fecha',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
              Text('Usuario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              Text('Resultado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ]),
            for (var d in dataRsp)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    //d['shootingDate'],
                    this.formatDate(d['shootingDate']),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    //d['id'].toString(),
                    d['firstName'] + ' ' + d['lastName'],
                    textAlign: TextAlign.center,
                  ),
                ),
                //strRsp(int.parse(d['result'])),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    d['result'].toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ])
          ],
        ),
      ),
          SizedBox(height: 60)
    ]);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Prediagnósticos'),
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
          // backgroundColor: Color.fromRGBO(39, 63, 123, 1.0),
        ),
        drawer: MenuLateral('home'),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.1), BlendMode.dstATop),
                      image: AssetImage("assets/img/background.jpeg"),
                      fit: BoxFit.contain)),
            ),
          ),
          SingleChildScrollView(child: content),
        ]),
        floatingActionButton: FloatingActionButtonGreen(
            txt: 'Crear un prediagnóstico',
            iconData: Icons.add,
            onPressed: () async {
              _asyncSimpleDialog(context);
            }));
  }
}

Future _asyncSimpleDialog(BuildContext context) async {
  var db = new DatabaseHelper();
  var users = await db.getUsers();
  return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:
              const Text('Seleccione un usuario:', textAlign: TextAlign.center),
          children: <Widget>[
            for (var u in users)
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FormPrediagnostico(u['id'])));

                  //   Navigator.pop(context, u['id']);
                },
                child: Text(u['firstName'] + ' ' + u['lastName'],
                    textAlign: TextAlign.center),
              ),
          ],
        );
      });
}
