import 'package:covid/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class WelcomePage extends StatelessWidget {
  final IntroSlider slider;
  const WelcomePage({Key key, this.slider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 10),
                          width: SizeConfig.heightMultiplier * 30,
                          child: Image(
                              image: AssetImage('assets/icons/icon_2.png'))),
                      Text(
                        "¡Bienvenido!\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "Stop Covid es una aplicación que permite hacer seguimiento de tu salud analizando síntomas asociados a un contagio por Covid-19.\n\n Te invitamos a usarla todos los días.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FlatButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => this.slider)),
                child: new Text("Continuar",
                    style: TextStyle(color: Colors.white)),
                color: Colors.black),
            SizedBox(height: SizeConfig.heightMultiplier * 10)
          ],
        ),
      ),
    );
  }
}
