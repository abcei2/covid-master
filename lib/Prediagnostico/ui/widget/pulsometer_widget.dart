import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:covid/audio_handler/audio_player_handler.dart';
import 'package:covid/chart.dart';
import 'package:covid/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PulsometerWidget extends StatefulWidget {
  var data;
  PulsometerWidget({data}) {
    this.data = data;
  }

  @override
  PulsometerWidgetView createState() {
    return PulsometerWidgetView();
  }
}

class PulsometerWidgetView extends State<PulsometerWidget>
    with SingleTickerProviderStateMixin {
  bool _toggled = false; // toggle button value
  List<SensorValue> _data = List<SensorValue>(); // array to store the values
  CameraController _controller;
  double _alpha = 0.3; // factor for the mean value
  AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage _image; // store the last camera image
  double _avg; // store the average value during calculation
  DateTime _now; // store the now Datetime
  Timer _timer; // timer for image processing
  List<int> arrBpm = [];
  final LocalStorage storage = new LocalStorage('covid_u');
  var data;
  int countCycle = 6;
  String percentStr = '0%';
  double percentInt = 0.0;
  AudioPlayer audioPlayerTono = AudioPlayer();

  @override
  void initState() {
    this.data = widget.data;
    storage.setItem('rsp_${this.data["id"]}', 0);
    if (storage.getItem('flagP') == false) {
      storage.setItem('flagP', true);
      WidgetsBinding.instance.addPostFrameCallback((_) => modalInfo(context));
    }
    super.initState();
    if (storage.getItem('rsp_${widget.data["id"]}') != null) {
      this._bpm = storage.getItem('rsp_${widget.data["id"]}');
    }

    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController
      ..addListener(() {
        setState(() {
          _iconScale = 1.0 + _animationController.value * 0.4;
        });
      });
  }

  Widget pageS() {
    return Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Coloque uno de sus dedos cubriendo el flash y la cámara de su celular mientras mira la pantalla.\n',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              Text(
                'Es importante presionar el dedo de forma suave.\n',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              Text(
                'Con la otra mano presione el botón iniciar.\n',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              Text(
                'Espera a tener la lectura de ritmo cardiaco.',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              Image.asset(
                "assets/gif/FCARDIACA.gif",
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
      isOverlayTapDismiss: false,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
    //Navigator.of(context).push(TutorialOverlay());
    Alert(
      style: alertStyle,
      context: context,
      type: AlertType.none,
      title: "Ritmo cardiaco",
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
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 15,
            width: SizeConfig.heightMultiplier * 15,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: <Widget>[
                  _controller != null && _toggled
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        )
                      : Container(
                          padding: EdgeInsets.all(12),
                          alignment: Alignment.center,
                          color: Colors.grey,
                        ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    child: Text(
                      _toggled ? "Cubre la cámara y el flash con tu dedo" : "",
                      style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.transparent
                          /* backgroundColor:
                              _toggled ? Colors.white : Colors.transparent */
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 15,
            width: SizeConfig.heightMultiplier * 15,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "BPM Estimado",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 3,
                      color: Colors.grey),
                ),
                Text(
                  (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 4,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
          )
        ],
      ),
      Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                MaterialButton(
                  shape: CircleBorder(
                      side: BorderSide(
                          color: Colors.red,
                          width: 1,
                          style: BorderStyle.solid)),
                  textColor: _toggled ? Colors.white : Colors.red,
                  color: _toggled ? Colors.red : null,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    if (_toggled) {
                      _untoggle();
                    } else {
                      _toggle();
                    }
                  },
                  child: Container(
                    height: SizeConfig.heightMultiplier * 8,
                    width: SizeConfig.heightMultiplier * 8,
                    child: Center(
                      child: Text(
                        _toggled ? 'Detener' : 'Iniciar',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                /*Transform.scale(
                  scale: _iconScale,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                            _toggled ? Icons.favorite : Icons.favorite_border),
                        color: Colors.red,
                        iconSize: 120,
                        onPressed: () {
                          if (_toggled) {
                            _untoggle();
                          } else {
                            _toggle();
                          }
                        },
                      )
                    ],
                  ),
                ),*/
                CircularPercentIndicator(
                  radius: SizeConfig.heightMultiplier * 10,
                  lineWidth: 4.0,
                  percent: (percentInt / 100),
                  center: Text('${percentStr}'),
                  progressColor: Colors.red,
                  animation: true,
                  animationDuration: 800,
                  animateFromLastPercent: true,
                )
              ]),
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: Text(
                  "ESTA MEDICIÓN ES OPCIONAL. SI SU CELULAR NO LE PERMITE REALIZAR LA LECTURA PRESIONE \"ANALIZAR DATOS\".",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
    ]);
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    //storage.deleteItem('rsp_${this.data["id"]}');
    setState(() {
      this._bpm = 0;
      arrBpm = [];
      //_controllerArrData.clear();
    });
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  void _toggle() {
    print('_toggle');
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController?.repeat(reverse: true);
      setState(() {
        this._bpm = 0;
        _toggled = true;
        this.percentStr = '0%';
        this.percentInt = 0.0;
      });
      // after is toggled
      _initTimer();
      _updateBPM();
    });
  }

  Future<void> _untoggle() async {
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    setState(() {
      _toggled = false;
    });
    await Vibration.vibrate(duration: 1000);
    SoundController.play('audio/tono.mp3');
    var sum = this.arrBpm.reduce((previous, current) => current += previous);
    var avg = sum / this.arrBpm.length;
    double varianza = 0;
    for (var item in this.arrBpm) {
      varianza += pow((item - avg), 2);
    }
    varianza = varianza / this.arrBpm.length;
    var desv = sqrt(varianza);
    double max = double.parse((avg + desv).toStringAsFixed(1));
    double min = double.parse((avg - desv).toStringAsFixed(1));
    var p2 =
        this.arrBpm.where((element) => element > min && element < max).toList();
    if (p2.last != null) {
      if (p2.last > 30 && p2.last < 150) {
        storage.setItem('rsp_${this.data["id"]}', p2.last);
      } else {
        storage.setItem('rsp_${this.data["id"]}', 0);
        print('------------- showDialog');
        showDialog(
          context: context,
          builder: (alertContext) => AlertDialog(
            title: const Text("Información"),
            content: const Text(
                "No se tomó de forma correcta el ritmo cardíaco, por favor vuelve a intentarlo."),
            actions: [
              new FlatButton(
                child: const Text("Aceptar"),
                onPressed: () => Navigator.pop(alertContext),
              ),
            ],
          ),
        );
      }

      setState(() {
        this._bpm = p2.last;
      });
    } else {
      setState(() {
        this._bpm = 0;
      });
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.medium);
      await _controller.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        _controller.flash(true);
      });
      _controller.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint(Exception);
    }
  }

  void _initTimer() {
    var i = 0;
    _timer = Timer.periodic(Duration(milliseconds: 200 ~/ _fs), (timer) {
      if (_toggled) {
        i++;
        if (_image != null) _scanImage(_image);
        if (this.arrBpm.length == countCycle) {
          _untoggle();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, _avg));
    });
  }

  void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
/*         if (i == 1) {
          _previous = _values[i].time.millisecondsSinceEpoch;
        } else {
          _counter++;
          _bpm +=
              60 * 1000 / (_values[i].time.millisecondsSinceEpoch - _previous);
        } */
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }

      if (_counter > 0) {
        _bpm = _bpm / _counter;
        var p1 = ((1 - _alpha) * _bpm + _alpha * _bpm).toInt();

        double per = ((this.arrBpm.length + 1) * 100) / countCycle;
        int per2 = num.parse(per.toStringAsFixed(0));

        setState(() {
          this._bpm = p1;
          this.arrBpm.add(p1);
          this.percentStr = '${per2}%';
          this.percentInt = per;
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }
}
