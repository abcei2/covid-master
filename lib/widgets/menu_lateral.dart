import 'package:covid/Prediagnostico/ui/screens/homePrediagnostico.dart';
import 'package:covid/User/ui/screens/editUserPrincipal.dart';
import 'package:covid/User/ui/screens/listUsers.dart';
import 'package:covid/services/database_helper.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';

class MenuLateral extends StatelessWidget {
  var name;
  var email;
  String opcion;

  MenuLateral(this.opcion) {
    var db = new DatabaseHelper();
    db.getUserId(1).then((value) {
      name = value.firstName + ' ' + value.lastName;
      email = value.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.opcion == 'perfil') {
      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              arrowColor: Colors.black,
              accountName: Text(name, style: TextStyle(color: Colors.black)),
              accountEmail: Text(email, style: TextStyle(color: Colors.black)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/profile.jpg"),
                      fit: BoxFit.cover)),
            ),
            Ink(
              color: Colors.indigo,
              child: new ListTile(
                title: Text(
                  "Mi perfil",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditUserPrincipal()));
                },
              ),
            ),
            new ListTile(
              title: Text("Realizar prediagnóstico"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePrediagnostico()));
              },
            ),
            new ListTile(
              title: Text("Crear/Modificar usuarios"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ListUsers()));
              },
            ),
          ],
        ),
      );
    } else if (this.opcion == 'home') {
      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              arrowColor: Colors.black,
              accountName: Text(name, style: TextStyle(color: Colors.black)),
              accountEmail: Text(email, style: TextStyle(color: Colors.black)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/profile.jpg"),
                      fit: BoxFit.cover)),
            ),
            new ListTile(
              title: Text("Mi perfil"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditUserPrincipal()));
              },
            ),
            Ink(
              color: Colors.indigo,
              child: new ListTile(
                title: Text(
                  "Realizar prediagnóstico",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePrediagnostico()));
                },
              ),
            ),
            new ListTile(
              title: Text("Crear/Modificar usuarios"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ListUsers()));
              },
            ),
          ],
        ),
      );
    } else if (this.opcion == 'usuarios') {
      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              arrowColor: Colors.black,
              accountName: Text(name, style: TextStyle(color: Colors.black)),
              accountEmail: Text(email, style: TextStyle(color: Colors.black)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/profile.jpg"),
                      fit: BoxFit.cover)),
            ),
            new ListTile(
              title: Text("Mi perfil"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditUserPrincipal()));
              },
            ),
            new ListTile(
              title: Text("Realizar prediagnóstico"),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePrediagnostico()));
              },
            ),
            Ink(
              color: Colors.indigo,
              child: new ListTile(
                title: Text(
                  "Crear/Modificar usuarios",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ListUsers()));
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
