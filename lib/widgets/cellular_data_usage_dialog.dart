import 'package:flutter/material.dart';

class CellularDataUsageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.data_usage,
                  size: 60,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Aviso:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Recuerde que este aplicativo hace uso de internet para compartir datos de su pre-diagnóstico, aunque funciona incluso sin conexión de datos.  Para no generar costos adicionales en su cuenta de telefonía celular, se recomienda hacer uso de una red WIFI si cuenta con ella.",
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: FlatButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          child: Text(
                            "Aceptar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ))))
            ]))
    ]),
        ));
  }
}
