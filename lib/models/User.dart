import 'package:flutter/material.dart';

class User {
  static String table = 'user';

  String deviceId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String numberIdentification;
  int principal;
  String longitude;
  String latitude;
  int id;
  int syncData;
  String genero;
  String birthDay;

  User(
      {Key key,
      this.deviceId,
      this.firstName,
      this.lastName,
      this.email,
      this.id,
      this.phone,
      this.numberIdentification,
      this.principal,
      this.latitude,
      this.longitude,
      this.syncData,
      this.genero,
      this.birthDay});

  User.map(dynamic obj) {
    this.id = obj["id"];
    this.deviceId = obj["deviceId"];
    this.firstName = obj["firstName"];
    this.lastName = obj["lastName"];
    this.email = obj["email"];
    this.phone = obj["phone"];
    this.numberIdentification = obj["numberIdentification"];
    this.principal = obj["principal"];
    this.latitude = obj["latitude"];
    this.longitude = obj["longitude"];
    this.syncData = obj["syncData"];
    this.genero = obj["genero"];
    this.birthDay = obj["birthDay"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["deviceId"] = deviceId;
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["email"] = email;
    map["phone"] = phone;
    map["numberIdentification"] = numberIdentification;
    map["principal"] = principal;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["syncData"] = syncData;
    map["genero"] = genero;
    map["birthDay"] = birthDay;
    return map;
  }
}
