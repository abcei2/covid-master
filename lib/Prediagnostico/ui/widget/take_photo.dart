import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';

class TakePhoto extends StatefulWidget {
  var data;
  List<String> questions;

  TakePhoto(this.data) {
    this.questions = this.data['values'];
  }

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  int groupValue = -1;
  List<Widget> list = new List<Widget>();
  final LocalStorage storage = new LocalStorage('covid_u');
  File _image;
  final picker = ImagePicker();
  var bytes;
  final cameras = availableCameras();
  var c;
  @override
  void initState() {
    super.initState();
    c = Material(
      child: Container(
        alignment: Alignment(0.0, 0.0),
        child: Text("Foto cargada"),
      ),
      color: Colors.grey,
    );
    if (storage.getItem('rsp_${widget.data["id"]}') != null) {
      _image = File(storage.getItem('rsp_${widget.data["id"]}'));
      // this._bpm = storage.getItem('rsp_${widget.data["id"]}');
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        imageQuality: 60,
        maxWidth: 400.0,
        maxHeight: 400.0,
        source: ImageSource.camera);

    Future<Uint8List> imageBytes = pickedFile.readAsBytes();

    await imageBytes.then((value) {
      var base64 = base64Encode(value);
      print('pickedFile.path)-------');
      print(pickedFile.path);
      print('pickedFile.path)-------');
      storage.setItem('rsp_${widget.data["id"]}', pickedFile.path);
      // storage.setItem('rsp_${widget.data["id"]}', base64);
    });
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RaisedButton(
            onPressed: getImage,
            child: Text('Tomar foto'),
          ),
          Container(
            height: screenWidth / 2.1,
            width: screenWidth / 2.1,
            /* child: Material(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                child: Text("Foto cargada"),
              ),
              color: Colors.grey,
            ), */
            child: _image == null ? c : Image.file(_image),
          )
        ],
      ),
    );
  }
}
