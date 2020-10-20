import 'dart:convert';

import 'dart:typed_data';

class Result {
  static String table = 'result';

  String id;
  int idUser;
  String firstName;
  String lastName;
  String result;
  int syncData;
  Uint8List picture;
  String latitude;
  String longitude;
  String shootingDate;

  Result(
      {Key,
      key,
      this.id,
      this.idUser,
      this.firstName,
      this.lastName,
      this.result,
      this.syncData,
      this.picture,
      this.latitude,
      this.longitude,
      this.shootingDate});

  Result.map(dynamic obj) {
    this.id = obj["id"];
    this.idUser = obj["idUser"];
    this.firstName = obj["firstName"];
    this.lastName = obj["lastName"];
    this.result = obj["result"];
    this.syncData = obj["syncData"];
    this.picture = obj["picture"];
    this.latitude = obj["latitude"];
    this.longitude = obj["longitude"];
    this.shootingDate = obj["shootingDate"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["idUser"] = idUser;
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["result"] = result;
    map["syncData"] = syncData;
    map["picture"] = picture;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["shootingDate"] = shootingDate;
    return map;
  }
}
