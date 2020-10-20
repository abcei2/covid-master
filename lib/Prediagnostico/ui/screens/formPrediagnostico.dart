import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:covid/config/size_config.dart';
import 'package:covid/services/sync_data.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:covid/Prediagnostico/ui/widget/btnSteps.dart';
import 'package:covid/Prediagnostico/ui/widget/question.dart';
import 'package:covid/models/Answer.dart';
import 'package:covid/models/Result.dart';
import 'package:covid/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:geolocator/geolocator.dart' as g;

class FormPrediagnostico extends StatefulWidget {
  final idUser;
  FormPrediagnostico(this.idUser);
  @override
  FormPrediagnosticoView createState() {
    return FormPrediagnosticoView(this.idUser);
  }
}

class FormPrediagnosticoView extends State<FormPrediagnostico> {
  double iconSize = 40;
  double percentage = 0.0;
  bool flag = true;
  String pr;
  int stepCurrent;
  int totalStep;
  final LocalStorage storage = new LocalStorage('covid_u');
  var dataUser;
  var db = new DatabaseHelper();
  var name;
  Position _currentPosition;
  JSContext _jsContext;
  String contentNetwork;
  String customPathBreathing = '/audio_recorder_breathing_';
  String customPathCough = '/audio_recorder_cough_';

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  Future<void> initState() {
    super.initState();
    _init();
    _jsContext = JSContext.createInGroup();
    getPermisos();
  }

  getPermisos() async {
    //await FlutterAudioRecorder.hasPermissions;
  }

  _init() async {
    _activateGps();
    customPathBreathing = '/audio_recorder_breathing_';
    customPathCough = '/audio_recorder_cough_';

    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }
    var knockDir1 =
        await new io.Directory('${appDocDirectory.path}/muestraudios/breathing')
            .create(recursive: true);
    var knockDir2 =
        await new io.Directory('${appDocDirectory.path}/muestraudios/cough')
            .create(recursive: true);

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPathBreathing = knockDir1.path +
        customPathBreathing +
        DateTime.now().millisecondsSinceEpoch.toString();
    customPathCough = knockDir2.path +
        customPathCough +
        DateTime.now().millisecondsSinceEpoch.toString();
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

  FormPrediagnosticoView(idUser) {
    _getCurrentLocation();
    db.getUserId(idUser).then((value) {
      setState(() {
        dataUser = value;
        name = StringUtils.capitalize(value.firstName) +
            ' ' +
            StringUtils.capitalize(value.lastName);
      });
    });
    storage.clear();

    storage.setItem('flagR', false);
    storage.setItem('flagC', false);
    storage.setItem('flagP', false);

    stepCurrent = 0;
    totalStep = arrQuestion.length;
  }

  List<Map<String, dynamic>> arrQuestion = [
    {
      'id': 1,
      'label': 'ANTECEDENTES PATOLÓGICOS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Enfermedad de base o condición preexistente.'
    },
    {
      'id': 2,
      'label': 'ANTECEDENTES QUIRÚRGICOS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Responda si le han practicado alguna cirugía de cualquier tipo en algún momento.'
    },
    {
      'id': 3,
      'label': 'ANTECEDENTES ALÉRGICOS',
      'type': 'check',
      'values': ['Si', 'No']
    },
    {
      'id': 4,
      'label': 'TIENE RESTRICCIONES ALIMENTARIAS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Responda si tiene restringido el consumo de ciertos alimentos ya sea por razones médicas o de otra índole.'
    },
    {
      'id': 5,
      'label': 'HACE EJERCICIO',
      'type': 'check',
      'values': ['Si', 'No']
    },
    {
      'id': 6,
      'label': 'TIENE O HA TENIDO FIEBRE HOY',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Aumento temporal en la temperatura corporal por encima de 38°C, tanto si usted experimenta sensación de fiebre (medición subjetiva) como si dispone del dato medido con un termómetro (medición objetiva).'
    },
    {
      'id': 7,
      'label': 'DIAFORESIS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Sudoración profusa, excesiva. No proporcional al clima.'
    },
    {
      'id': 8,
      'label': 'ESCALOFRIO',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Episodio de temblores, y/o palidez y sensación de frío.'
    },
    {
      'id': 9,
      'label': 'PRESENTA TOS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Expulsión súbita y ruidosa de aire de los pulmones.'
    },
    {
      'id': 10,
      'label': 'RINORREA/ESPUTO',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Secreción de moco o flema, por nariz o boca, mezclado con saliva, que se expectora en patologías pulmonares. Es decir si “desgarra o no desgarra”.'
    },
    {
      'id': 11,
      'label': 'ODINOFAGIA',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Dolor de garganta, sensación dolorosa al tragar.'
    },
    {
      'id': 12,
      'label': 'CEFALEA',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Cualquier tipo de dolor de cabeza.'
    },
    {
      'id': 13,
      'label': 'ANOSMIA/HIPOSMIA',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Pérdida completa del sentido del olfato. / Pérdida parcial del sentido del olfato.'
    },
    {
      'id': 14,
      'label': 'AGEUSIA',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Pérdida total de la capacidad de apreciar sabores.'
    },
    {
      'id': 15,
      'label': 'RASH/BROTE',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Erupción o brote en la piel con cambios en el color o la textura.'
    },
    {
      'id': 16,
      'label': 'TIENE NÁUSEAS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Ganas de vomitar.'
    },
    {
      'id': 17,
      'label': 'TIENE VÓMITO',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Expulsión violenta e involuntaria por la boca del contenido del estómago y de las porciones altas del duodeno.'
    },
    {
      'id': 18,
      'label': 'DIARREA',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Deposición, tres o más veces al día (o con una frecuencia mayor que la normal para la persona) de heces blandas o líquidas.'
    },
    {
      'id': 19,
      'label': 'DOLOR ABDOMINAL',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Dolor en la parte del cuerpo comprendida entre el tórax y la pelvis.'
    },
    {
      'id': 20,
      'label': 'MIALGIAS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Dolor muscular, puede afectar a uno o varios músculos del cuerpo.'
    },
    {
      'id': 21,
      'label': 'ARTRALGIAS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Dolor en las articulaciones.'
    },
    {
      'id': 22,
      'label': 'ASTENIA/ADINAMIA',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Debilidad, cansancio, fatiga; carencia o pérdida de fuerza y energía / Extremada debilidad muscular que impide los movimientos del enfermo. '
    },
    {
      'id': 23,
      'label': 'DISNEA',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg': 'Dificultad para respirar. Sensación de asfixia o falta de aire.'
    },
    {
      'id': 24,
      'label': 'HA TENIDO SARS',
      'type': 'check',
      'values': ['Si', 'No'],
      'msg':
          'Síndrome Respiratorio Agudo Grave. SOLAMENTE SI USTED TIENE UN DIAGNÓSTICO PREVIO DE ESTA ENFERMEDAD'
    },
    {
      'id': 25,
      'label': 'GRABACIÓN DE LA RESPIRACIÓN',
      'type': 'audio_breathing'
    },
    {'id': 26, 'label': 'GRABACIÓN DE LA TOS', 'type': 'audio_cough'},
    {'id': 27, 'label': 'RITMO CARDIACO', 'type': 'bpm'},
    //{'id': 28, 'label': 'TOMAR FOTO', 'type': 'take_photo'},
  ];

  Future<String> _runJs() async {
    print("Ejecutando prediagnóstico...");
    setState(() {
      _status = "Ejecutando prediagnóstico...";
      percentStr = 50;
    });
    await Future.delayed(Duration(seconds: 1));
    try {
      var arrB = arrQuestion[arrQuestion.length - 3];
      var arrC = arrQuestion[arrQuestion.length - 2];

      var bufferResp = io.File(storage.getItem('rsp_${arrB['id']}'));
      var bufferTos = io.File(storage.getItem('rsp_${arrC['id']}'));

      List<int> arr = [];
      for (var i = 0; i < (arrQuestion.length - 3); i++) {
        var key = arrQuestion[i];
        var rsp = storage.getItem("rsp_${key['id']}");
        rsp = ((rsp == 1) ? 0 : 1);
        arr.add(rsp);
      }

      print('bufferResp.path');
      print(bufferResp.path);
      print('bufferTos.path');
      print(bufferTos.path);

      var arrBpm = arrQuestion[arrQuestion.length - 1];
      var bpm = storage.getItem("rsp_${arrBpm['id']}");
      var fileScript = await _localFile;
      var fileRed = await _localFileRedNeuronal;

      String bufferRespString = bufferResp.readAsStringSync().toString();
      String bufferTosString = bufferTos.readAsStringSync().toString();

      print('bufferRespString.length');
      print(bufferRespString.length);
      print('bufferTosString.length');
      print(bufferTosString.length);
      print("bpm");
      print(bpm);
      print("arr");
      print(arr);

      var script =
          "${fileScript.path} MainFunction($bufferTosString,44100, $bufferRespString, 44100, $arr, '${fileRed.path}', '$bpm');";
      JSValue jsValue = _jsContext.evaluate(script);

      String resp = jsValue.string;
      print("respuesta del script:");
      print(resp);

      if (resp.contains('null') || resp.contains('BAD')) {
        /* bufferResp.deleteSync();
        bufferTos.deleteSync(); */
        return 'null';
      }

      setState(() {
        _status = "Finalizando prediagnóstico...";
        percentStr = 100;
      });
      String latitude =
          _currentPosition != null ? _currentPosition.latitude.toString() : '0';
      String longitude = _currentPosition != null
          ? _currentPosition.longitude.toString()
          : '0';
      Result itemResult = Result(
          latitude: latitude,
          longitude: longitude,
          syncData: 0,
          idUser: dataUser.id,
          shootingDate: DateTime.now().toString(),
          firstName: dataUser.firstName,
          lastName: dataUser.lastName,
          result: resp);
      var idRsp = await db.saveResult(itemResult);

      for (var i = 0; i < (arrQuestion.length); i++) {
        var key = arrQuestion[i];
        var rsp = storage.getItem("rsp_${key['id']}");
        Answer itemAnswer = Answer(
            idResult: idRsp,
            syncData: 0,
            idUser: dataUser.id,
            firstName: dataUser.firstName,
            lastName: dataUser.lastName,
            question: key['id'].toString(),
            answer: rsp.toString());
        await db.saveAnswer(itemAnswer);
      }

      /**
       * Se eliminan los archivos de audio de forma provisional mientras se arregla los servicios de envio a la nube
       */
      /* bufferResp.deleteSync();
      bufferTos.deleteSync(); */
      bufferTos = null;
      bufferResp = null;
      await Future.delayed(Duration(seconds: 1));
      return resp;
    } catch (error) {
      print("error");
      print(error.toString());
      return 'null';
    }
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

  Future<File> get _localFile async {
    final path = await rootBundle.loadString('assets/script/js.txt');
    return File('$path');
  }

  Future<File> get _localFileRedNeuronal async {
    final path = await rootBundle.loadString('assets/json/red_neuronal.txt');
    return File('$path');
  }

  Future<File> get _localFileBufferResp async {
    final path = await rootBundle.loadString('assets/json/respiracion.txt');
    return File('$path');
  }

  Future<File> get _localFileBufferTos async {
    final path = await rootBundle.loadString('assets/json/tos.txt');
    return File('$path');
  }

  bool _isLoading = false;
  String _status;
  var percentStr = 0;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final porcentage = Container(
      margin: EdgeInsets.only(top: 15.0),
      child: FittedBox(
        child: LinearPercentIndicator(
            width: SizeConfig.widthMultiplier * 80,
            //fillColor: Colors.green,
            lineHeight: SizeConfig.heightMultiplier * 2,
            percent: (percentage / 100),
            center: Text(
              "$percentage%",
              style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.6),
            ),
            linearStrokeCap: LinearStrokeCap.roundAll,
            backgroundColor: Colors.grey,
            progressColor: Colors.blue),
      ),
    );

    // TODO: implement build
    final content = Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
          child: Column(
            children: [
              Text(
                'Cuestionario para el usuario:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontSize: SizeConfig.textMultiplier * 3,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '"${name}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  //fontSize: SizeConfig.textMultiplier * 3.8,
                ),
              )
            ],
          )),
    ]);

    Widget loadingView() {
      return Container(
        height: screenHeight,
        child: Column(
          children: [
/*           SizedBox(
            height: screenHeight / 3,
          ), */
            Container(
              padding: EdgeInsets.only(top: screenHeight / 10),
              child: Text("Espere un momento por favor"),
            ),
            Container(
              padding: EdgeInsets.only(top: screenHeight / 8),
              child: CircularPercentIndicator(
                radius: 150.0,
                lineWidth: 10.0,
                percent: percentStr / 100,
                center: Text('${percentStr}%'),
                progressColor: Colors.red,
                animation: true,
                animationDuration: 1500,
                animateFromLastPercent: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(_status),
            ),
            //Text(status)
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: _isLoading ? Text('Procesando') : Text('Cuestionario'),
          backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
        ),
        body: SafeArea(
          child: Stack(
            children: [
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
              Container(
                  //height: screenHeight,
                  child: Center(
                      child: _isLoading
                          ? loadingView()
                          : Column(children: <Widget>[
                              content,
                              porcentage,
                              Expanded(
                                child: Question(
                                  customPathBreathing: customPathBreathing,
                                  customPathCough: customPathCough,
                                  dataQuestion: arrQuestion[stepCurrent],
                                  flag: true,
                                  onPressed: () {},
                                ),
                              ),
                              BtnSteps(
                                  flag: this.flag,
                                  dataQuestion: arrQuestion[stepCurrent],
                                  // height: 90.0,
                                  onPressedBack: () {
                                    storage.setItem('flagR', false);
                                    storage.setItem('flagC', false);
                                    storage.setItem('flagP', false);
                                    setState(() {
                                      if (stepCurrent == 1) {
                                        this.flag = true;
                                      }
                                      stepCurrent--;
                                      double per =
                                          (stepCurrent * 100) / totalStep;
                                      percentage = num.parse(
                                          per.toStringAsExponential(2));
                                    });
                                  },
                                  onPressedForward: () async {
                                    //  var step = stepCurrent + 1;
                                    storage.setItem('flagR', false);
                                    storage.setItem('flagC', false);

                                    if ((arrQuestion[stepCurrent]["type"] ==
                                                'take_photo' ||
                                            arrQuestion[stepCurrent]["type"] ==
                                                'check' ||
                                            arrQuestion[stepCurrent]["type"] ==
                                                'bpm') &&
                                        storage.getItem(
                                                'rsp_${arrQuestion[stepCurrent]["id"]}') ==
                                            null) {
                                      storage.setItem('flagP', false);
                                      String msg;
                                      switch (arrQuestion[stepCurrent]
                                          ["type"]) {
                                        case 'check':
                                          msg = 'Debes seleccionar una opción.';
                                          break;
                                        case 'take_photo':
                                          msg =
                                              'Debes tomarte la foto para el registro.';
                                          break;
                                        case 'bpm':
                                          msg =
                                              'Debes permitir a la aplicación leer tu ritmo cardíado.';
                                          break;
                                        default:
                                      }
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "Error",
                                        desc: msg,
                                        // desc: "Debes seleccionar una opción.",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Cerrar",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            width: 120,
                                          )
                                        ],
                                      ).show();
                                    } else if ((arrQuestion[stepCurrent]
                                                    ["type"] ==
                                                'audio_cough' ||
                                            arrQuestion[stepCurrent]["type"] ==
                                                'audio_breathing') &&
                                        storage.getItem(
                                                'rsp_${arrQuestion[stepCurrent]["id"]}_flag') ==
                                            null) {
                                      storage.setItem('flagP', false);
                                      String msg;
                                      switch (arrQuestion[stepCurrent]
                                          ["type"]) {
                                        case 'audio_breathing':
                                          msg =
                                              'La grabación de la respiración debe ser de 30 segundos.';
                                          break;
                                        case 'audio_cough':
                                          msg =
                                              'La grabación de la tos debe ser de 10 segundos.';
                                          break;
                                        default:
                                      }
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "Error",
                                        desc: msg,
                                        // desc: "Debes seleccionar una opción.",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Cerrar",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            width: 120,
                                          )
                                        ],
                                      ).show();
                                    } else {
                                      if ((totalStep - 1) == stepCurrent) {
                                        print("Ultimo paso");
                                        setState(() {
                                          _isLoading = true;
                                          _status = "Enviando datos...";
                                          percentStr = 20;
                                        });
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        String success = await _runJs();
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        success = success ?? false;
                                        showResult(success);
                                      } else {
                                        setState(() {
                                          this.flag = false;
                                          stepCurrent++;
                                          double per =
                                              (stepCurrent * 100) / totalStep;
                                          percentage = num.parse(
                                              per.toStringAsExponential(2));
                                        });
                                      }
                                    }
                                  })
                            ]))),
            ],
          ),
        ));
  }

  void showResult(String result) async {
    Alert(
      style: AlertStyle(
        isOverlayTapDismiss: false,
        isCloseButton: false,
      ),
      context: context,
      type: result.contains('null') ? AlertType.error : AlertType.success,
      title: result.contains('null') ? "Error" : "Éxito",
      desc: result.contains('null')
          ? "Ha ocurrido un error, intente de nuevo"
          : "Se creó con éxito el prediagnóstico",
      buttons: [
        DialogButton(
          child: Text(
            "Cerrar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if (!result.contains('null')) {
              syncData();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/results', (Route<dynamic> route) => false,
                  arguments: {'nameUser': name, 'probability': result});
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          },
          width: 120,
        )
      ],
    ).show();
  }

  //void loadingGif(context) {
  Future<void> loadingGif(context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      content: Image.asset(
        "assets/gif/spinner.gif",
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
