import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:audio_streamer/audio_streamer.dart';
import 'package:covid/audio_handler/audio_player_handler.dart';
import 'package:covid/widgets/blink_widget.dart';
import 'package:covid/widgets/permissions_alerts.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:vibration/vibration.dart';

class RecorderBreathing extends StatefulWidget {
  final data;
  final String customPathBreathing;

  RecorderBreathing({Key key, this.data, this.customPathBreathing}) {}

  @override
  State<StatefulWidget> createState() => new RecorderBreathingView();
}

class RecorderBreathingView extends State<RecorderBreathing> {
  //FlutterAudioCapture _plugin = new FlutterAudioCapture();
  List<double> buffer = List();
  AudioStreamer _streamer = AudioStreamer();
  List<double> _audio = [];
  BuildContext dialogContext;
  String _status;
  Color _textColor = Colors.black;
  RecorderBreathingView() {
    if (storage.getItem('flagR') == false) {
      storage.setItem('flagR', true);
      WidgetsBinding.instance.addPostFrameCallback((_) => modalInfo(context));
    }
  }
  final LocalStorage storage = new LocalStorage('covid_u');
  var data;
  bool flagStop = true;
  bool flagPlay = true;

  bool _isRecording = false;
  int _isRecordingInt = 1;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  String pathPlay;
  Timer _timer;
  int _startTimer = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (storage.getItem('rsp_${widget.data["id"]}_flag') != null) {
      this.setState(() {
        _startTimer = 30;
        _isRecordingInt = 3;
      });
    } else if (storage.getItem('rsp_${widget.data["id"]}_flag') == null &&
        storage.getItem('rsp_${widget.data["id"]}') != null) {
      io.File f = io.File(storage.getItem('rsp_${widget.data["id"]}'));
      print('----- guardado');
      var j = jsonDecode(f.readAsStringSync());
      var s = j.length / 44100;

      s = s.toStringAsFixed(1);
      s = s.split('.');
      if (s.length > 1) {
        s = s[0];
      } else {
        s = s;
      }
      print(s);
      this.setState(() {
        _startTimer = int.parse(s);
        _isRecordingInt = 3;
      });
      print('----- guardado');
    }
  }

  Widget pageS() {
    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Para un correcto registro:'
                    '\n\n1- Intente permanecer en una zona de bajo ruido.'
                    '\n\n2- Para iniciar la grabación presione el botón GRABAR que se mostrará en la pantalla.'
                    '\n\n3- Inmediatamente después de presionar GRABAR  coloque el celular en la zona baja de la garganta (vea el dibujo) asegurando contacto suave del celular con su piel.'
                    '\n\n4- Inhale y exhale profundamente de forma fluida intentando no agitarse.'
                    '\n\n5- Espere a que el celular le indique cuando la grabación haya concluido (30 segundos).\n',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              Image.asset(
                "assets/gif/RESP.gif",
                width: 300.0,
              ),
            ],
          ),
        ));
  }

  void modalInfo(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
    Alert(
      style: alertStyle,
      context: context,
      type: AlertType.none,
      title: "Respiración",
      content: pageS(),
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new FlatButton(
                      onPressed: start, //startRecorder,
                      child: _buildText2(),
                      color: Colors.lightBlue,
                    ),
                  ),
                  /*new FlatButton(
                    onPressed: stopRecorder,
                    child: new Text("Detener",
                        style: TextStyle(color: Colors.white)),
                    color: _isRecording
                        ? Colors.lightBlue
                        : Colors.blueAccent.withOpacity(0.5),
                  ),*/
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
              Text("Tiempo: $_startTimer segundos"),
              _status != null
                  ? Text(_status, style: TextStyle(color: _textColor))
                  : SizedBox()
            ]),
      ),
    );
  }

  void showRecordingModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Grabación de la respiración:",
                textAlign: TextAlign.center,
              ),
              BlinkWidget(
                children: <Widget>[
                  Icon(
                    Icons.fiber_manual_record,
                    color: Colors.red,
                  ),
                  Icon(Icons.fiber_manual_record, color: Colors.transparent),
                ],
                timer: 30,
              ),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    stop();
                    //stopRecorder();
                  },
                  child: new Text("Detener",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.lightBlue),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  /*void listener(dynamic obj) {
    List<double> objRecortado = List();
    obj.forEach((element) {
      objRecortado.add(double.parse((element).toStringAsFixed(8)));
    });
    var buffer2 = objRecortado.cast<double>();
    print(buffer2.length);
    print('---- bufferResp');
    this.buffer.addAll(buffer2);
  }
*/
  void onError(e) {
    print('-------------------');
    print(e.message);
    print('-------------------');
    //stopRecorderError();
    stopError();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
          "Ha ocurrido un error con la grabación del audio, por favor intente de nuevo"),
      backgroundColor: Colors.red,
    ));
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      setState(
        () {
          _startTimer = _startTimer + 1;
        },
      );
      if (_startTimer >= 30) {
        if (Navigator.of(dialogContext).canPop())
          Navigator.of(dialogContext).pop();
        //stopRecorder();
        stop();
      }
    });
  }

  Future<void> stopTimer() {
    _timer.cancel();
  }

  void onAudio(List<double> buffer) {
    List<double> objRecortado = List();
    buffer.forEach((element) {
      objRecortado.add(double.parse((element).toStringAsFixed(8)));
    });
    _audio.addAll(objRecortado);
    double secondsRecorded =
        _audio.length.toDouble() / _streamer.sampleRate.toDouble();
    print('$secondsRecorded seconds recorded.');
  }

  void start() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print("sin permisos");
        await noMicrophoneAlert(context);
      } else {
        if (_isRecording == true) {
          return;
        }
        this._audio.clear();
        storage.deleteItem('rsp_${widget.data["id"]}_flag');
        setState(() {
          _startTimer = 0;
          _isRecording = true;
        });

        showRecordingModal();
        startTimer();

        _streamer.start(onAudio).catchError(onError);

        this.setState(() {
          this._isRecording = true;
          _isRecordingInt = 2;
          flagPlay = true;
          // this._path[_codec.index] = path;
        });
        print('startRecorder');
      }
    } catch (err) {
      print('startRecorder error: $err');
      setState(() {
        stopError();
        this._isRecording = false;
      });
    }
  }

  Future<void> stopError() async {
    try {
      print("stopError");
      await stopTimer();
      await _streamer.stop();
      if (_isRecording == false) {
        return;
      }

      this.buffer.clear();
      await Vibration.vibrate(duration: 1000);
      SoundController.play('audio/audio_stop.mp3');
      this.setState(() {
        _isRecordingInt = 3;
        _isRecording = false;
        flagPlay = false;
        Navigator.of(dialogContext).pop();
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void stop() async {
    try {
      if (_isRecording == false) {
        return;
      }
      bool stopped = await _streamer.stop();
      stopTimer();
      setState(() {
        _isRecording = stopped;
        _status = "Almacenando audio...";
      });
      await Future.delayed(Duration(seconds: 1));
      print("_audio-length");
      print(_audio.length);
      io.File fileBufferBreathing =
          io.File(widget.customPathBreathing + '.txt');
      fileBufferBreathing
          .writeAsStringSync(this._audio.toString().replaceAll(" ", ""));
      this._audio.clear();
      storage.setItem(
          'rsp_${widget.data["id"]}', fileBufferBreathing.path.toString());
      if (_startTimer >= 30) {
        storage.setItem('rsp_${widget.data["id"]}_flag', true);
      }
      Vibration.vibrate(duration: 1000);
      SoundController.play('audio/audio_stop.mp3');
      this.setState(() {
        _status = "Audio almacenado exitosamente";
        _textColor = Colors.green;
        _isRecordingInt = 3;
        flagPlay = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

/*
  void startRecorder() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        //throw RecordingPermissionException("Microphone permission not granted");
      }
      if (_isRecording == true) {
        return;
      }
      this.buffer.clear();
      storage.deleteItem('rsp_${widget.data["id"]}_flag');
      setState(() {
        _startTimer = 0;
        _isRecording = true;
      });

      showRecordingModal();
      startTimer();
       _plugin.start(listener, onError,
          sampleRate: 44100, bufferSize: 3000);

      this.setState(() {
        this._isRecording = true;
        _isRecordingInt = 2;
        flagPlay = true;
        // this._path[_codec.index] = path;
      });

      print('startRecorder 1');
    } catch (err) {
      print('startRecorder error: $err');
      setState(() {
        stopRecorderError();
        this._isRecording = false;
      });
    }
  }

  void stopRecorderError() async {
    try {
      print("stopREcorderError");
      await stopTimer();
      if (_isRecording == false) {
        return;
      }

      _plugin.stop();
      this.buffer.clear();
      await Vibration.vibrate(duration: 1000);
      SoundController.play('audio/audio_stop.mp3');
      this.setState(() {
        _isRecordingInt = 3;
        _isRecording = false;
        flagPlay = false;
        Navigator.of(dialogContext).pop();
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void stopRecorder() async {
    try {
      if (_isRecording == false) {
        return;
      }
      stopTimer();
      setState(() {
        _status = "Almacenando audio...";
      });
      await Future.delayed(Duration(seconds: 1));
      await _plugin.stop();
      print(this.buffer.length);
      print("this.buffer");
      io.File fileBufferBreathing =
          io.File(widget.customPathBreathing + '.txt');
      fileBufferBreathing
          .writeAsStringSync(this.buffer.toString().replaceAll(" ", ""));
      this.buffer.clear();
      storage.setItem(
          'rsp_${widget.data["id"]}', fileBufferBreathing.path.toString());
      if (_startTimer >= 30) {
        storage.setItem('rsp_${widget.data["id"]}_flag', true);
      }
      Vibration.vibrate(duration: 1000);
      SoundController.play('audio/audio_stop.mp3');
      this.setState(() {
        _status = "Audio almacenado";
        _isRecordingInt = 3;
        _isRecording = false;
        flagPlay = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }
*/

  Widget _buildText2() {
    var text = "";
    switch (_isRecordingInt) {
      case 1:
        {
          text = 'Grabar';
          break;
        }
      case 2:
        {
          text = 'Grabando...';
          break;
        }
      case 3:
        {
          text = 'Volver a grabar';
          break;
        }
      default:
        text = '33';
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }
}
