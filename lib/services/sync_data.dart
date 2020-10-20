import 'dart:io';

import 'data_manager.dart';
import 'database_helper.dart';

final List<String> questionNames = [
  "ant_patologicos",
  "ant_quirurgicos",
  "ant_alergicos",
  "ant_alimenticios",
  "ejercicio",
  "fiebre",
  "diaforesis",
  "escalofrio",
  "tos",
  "esputo",
  "odinofagia",
  "cefalea",
  "hiposmia",
  "ageusia",
  "brote",
  "nauseas",
  "vomito",
  "diarrea",
  "dolor_abdominal",
  "mialgias",
  "artralgias",
  "astenia",
  "disnea",
  "sars",
];

Map buildJson(List<dynamic> row) {
  Map json = Map();
  for (int i = 0; i < questionNames.length; i++) {
    json[questionNames[i]] = row[i]['answer'] == '1' ? 0 : 1;
  }
  json["frecuencia_cardiaca"] = row[26]['answer'].toString();
  print("Answers");
  print(json);
  return json;
}

String breathFilePath(List<dynamic> row) {
  return row[24]['answer'].toString();
}

String coughFilePath(List<dynamic> row) {
  return row[25]['answer'].toString();
}

Future<File> getFile(String path) async {
  return File(path);
}

Future<bool> deleteFile(String path) async {
  try {
    File file = await getFile(path);
    await file.delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> syncData() async {
  var db = new DatabaseHelper();
  List data = await db.getDataResultSync();
  print('----------');
  print('data');
  print(data);
  print('----------');

  data.forEach((resultToSync) {
    dataManager
        .registerDiagnostic(register: resultToSync)
        .then((response) async {
      print("Registro de diagnostico");
      print(response);
      if (response != null) {
        List dataAnswer =
            await db.getDataResultANSWERSync(resultToSync['idResult']);
        Map jsonAnswers = buildJson(dataAnswer);
        jsonAnswers['id_diagnostico'] = response;

        String pathBreathFile = breathFilePath(dataAnswer);
        String pathCoughFile = coughFilePath(dataAnswer);

        String answersResponse =
            await dataManager.registerAnswers(jsonAnswers: jsonAnswers);
        bool breathResponse = await dataManager.sendBreathFile(
            filePath: pathBreathFile, idDiagnostic: response);
        bool coughResponse = await dataManager.sendCoughFile(
            filePath: pathCoughFile, idDiagnostic: response);

        if (answersResponse != null && breathResponse && coughResponse) {
          db.setSyncData(resultToSync['idResult'].toString())
              .then((value) => print("Acualizado en la base de datos"));
          deleteFile(pathBreathFile)
              .then((value) => print("Respiracion borrada $value"));
          deleteFile(pathCoughFile)
              .then((value) => print("Tos borrada $value"));
        }
      }
    });
  });
}
