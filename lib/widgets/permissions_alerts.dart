import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

noLocationAlert(context) async {
  await Alert(
    context: context,
    type: AlertType.info,
    title: "Información",
    desc:
    "No se han activado los servicios de ubicación por lo tanto no podremos registrar su ubicación",
    buttons: [
      DialogButton(
        child: Text(
          "Continuar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        // onPressed: () => Navigator.pop(context, false),
        width: 120,
      )
    ],
  ).show();
}

noMicrophoneAlert(context) async {
  await Alert(
    context: context,
    type: AlertType.info,
    title: "Información",
    desc:
    "Por favor active el acceso al micrófono para continuar con el prediagnóstico.",
    buttons: [
      DialogButton(
        child: Text(
          "Continuar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        // onPressed: () => Navigator.pop(context, false),
        width: 120,
      )
    ],
  ).show();
}