import 'package:audioplayers/audioplayers.dart';
import 'package:covid/Prediagnostico/ui/widget/radio_set.dart';
import 'package:covid/Prediagnostico/ui/widget/record_audio_breathing.dart';
import 'package:covid/Prediagnostico/ui/widget/record_autio_cough.dart';
import 'package:covid/Prediagnostico/ui/widget/take_photo.dart';
import 'package:covid/Prediagnostico/ui/widget/pulsometer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

class Question extends StatefulWidget {
  final VoidCallback onPressed;
  final Map dataQuestion;
  final bool flag;
  final bool value2;
  //FlutterAudioRecorder recorderBreathing;
  FlutterAudioRecorder recorderCough;
  final String customPathBreathing;

  /* final FlutterSoundRecorder recorderModuleBreathing;
  final FlutterSoundPlayer playerModuleBreathing;
  final FlutterSoundRecorder recorderModuleCough;
  final FlutterSoundPlayer playerModuleCough; */

  final String customPathCough;

  bool rsp1 = false;
  bool rsp2 = false;
  Question(
      {Key key,
      @required this.onPressed,
      this.dataQuestion,
      this.flag,
      this.value2,
      this.recorderCough,
      this.customPathBreathing,
      this.customPathCough}) {}

  @override
  _Question createState() => _Question();
}

class _Question extends State<Question> {
  List<Widget> list = new List<Widget>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Container child;
    if (widget.dataQuestion['type'] == 'bpm') {
      child = Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                widget.dataQuestion['label'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: screenWidth,
                  child: Center(
                      child: PulsometerWidget(data: widget.dataQuestion))),
            ],
          ),
        ),
      );
    } else if (widget.dataQuestion['type'] == 'audio_breathing') {
      child = Container(
        child: Column(
          children: <Widget>[
            Text(
              widget.dataQuestion['label'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                width: screenWidth,
                child: RecorderBreathing(
                    customPathBreathing: widget.customPathBreathing,
                    data: widget.dataQuestion)),
          ],
        ),
      );
    } else if (widget.dataQuestion['type'] == 'audio_cough') {
      child = Container(
        child: Column(
          children: <Widget>[
            Text(
              widget.dataQuestion['label'],
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                width: screenWidth,
                child: Center(
                    child: RecorderCough(
                  customPathCough: widget.customPathCough,
                  data2: widget.dataQuestion,
                ))),
          ],
        ),
      );
    } else if (widget.dataQuestion['type'] == 'check') {
      child = Container(
        child: Column(
          children: <Widget>[
            Text(
              '¿' + widget.dataQuestion['label'] + '?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            widget.dataQuestion['msg'] != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                        child: Text(
                          widget.dataQuestion['msg'],
                          style: TextStyle(
                              fontSize: 14.0, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  )
                : Spacer(),
            RadioSet(widget.dataQuestion),
          ],
        ),
      );
    } else if (widget.dataQuestion['type'] == 'take_photo') {
      child = Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              widget.dataQuestion['label'],
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20.0),
                width: screenWidth,
                child: Center(child: TakePhoto(widget.dataQuestion))),
            // child: Center(child: RadioSet(widget.dataQuestion))),
          ],
        ),
      );
    }

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: child,
    ));
  }
}
