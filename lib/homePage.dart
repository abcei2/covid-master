import 'dart:async';
import 'package:covid/Prediagnostico/ui/screens/homePrediagnostico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Prediagnostico/ui/widget/record_audio_breathing.dart';
import 'widgets/menu_lateral.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageView createState() {
    return HomePageView();
  }
}

class HomePageView extends State<HomePage> {
  @override
  Future<void> initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID"),
        backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
      ),
      drawer: MenuLateral('home'),
      backgroundColor: Colors.white,
      body:
          //RecorderExample()
          SafeArea(
        child: ListView(
          children: <Widget>[
            new ListTile(
              title: Text("Prediagnósticos", textAlign: TextAlign.center),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePrediagnostico()));
              },
            ),
            new ListTile(
              title: Text("Usuarios", textAlign: TextAlign.center),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePrediagnostico()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
