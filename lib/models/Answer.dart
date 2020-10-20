import 'dart:convert';

class Answer {
  static String table = 'answer';

  String id;
  int idUser;
  String firstName;
  String lastName;
  String question;
  String answer;
  int syncData;
  int idResult;

  Answer(
      {Key,
      key,
      this.id,
      this.syncData,
      this.idUser,
      this.firstName,
      this.lastName,
      this.question,
      this.answer,
      this.idResult});

  Answer.map(dynamic obj) {
    this.id = obj["id"];
    this.idUser = obj["idUser"];
    this.firstName = obj["firstName"];
    this.lastName = obj["lastName"];
    this.question = obj["question"];
    this.answer = obj["answer"];
    this.syncData = obj["syncData"];
    this.idResult = obj["idResult"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["idUser"] = idUser;
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["question"] = question;
    map["answer"] = answer;
    map["syncData"] = syncData;
    map["idResult"] = idResult;
    return map;
  }
}
