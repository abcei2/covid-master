import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

final DataManager dataManager = _MockDataManager._internal();

class _MockDataManager extends DataManager {
  _MockDataManager._internal();

  @override
  Future<String> registerAnswers({Map jsonAnswers}) {
    print("registerAnswers");
    print(jsonAnswers);
    String url =
        'http://190.145.98.43:75/stop-covid/database/recibir.php?action=cuestionario';
    return http.post(url, body: jsonEncode(jsonAnswers)).then((response) {
      print(response.request);
      print(response.statusCode);
      print(response.body);
      try {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print("RETURN ");
          print(jsonResponse[0]);
          return jsonResponse[0];
        } else {
          return null;
        }
      } catch (error) {
        return null;
      }
    });
  }

  String calculateAge(DateTime date) {
    var today = new DateTime.now();
    var age = today.year - date.year;
    var month = today.month - date.month;
    if (month < 0 || (month == 0 && today.day < date.day)) {
      age--;
    }
    return age.toString();
  }

  @override
  Future<String> registerDiagnostic({Map register}) async {
    print("registerDiagnostic");
    print(register);
    DateTime dateRegister = DateTime.parse(register['shootingDate']);
    DateTime birthDate = DateTime.parse(register['birthDay']);
    Map json = {
      'id_dispositivo': register['deviceId'],
      'nombre': register['firstName'] + ' ' + register['lastName'],
      'cedula': register['numberIdentification'],
      'edad': calculateAge(birthDate),
      "genero": register['genero'],
      "celular": register['phone'],
      'longitud': register['longitude'],
      'latitud': register['latitude'],
      'fecha_registro':
          dateRegister.millisecondsSinceEpoch.toString().substring(0, 10),
      'resultado_analisis': register['result'],
      'frecuencia_buffer_tos': '16000',
      'frecuencia_buffer_respiracion': '16000',
    };
    print("json");
    print(json);
    String url =
        'http://190.145.98.43:75/stop-covid/database/recibir.php?action=registro';
    return http.post(url, body: jsonEncode(json)).then((response) {
      print(response.request);
      print(response.statusCode);
      print(response.body);
      try {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return jsonResponse[0]['id_diagnostico'];
        } else {
          return null;
        }
      } catch (error) {
        return null;
      }
    });
  }

  @override
  Future<bool> sendBreathFile({String filePath, String idDiagnostic}) async {
    File file = File(filePath);
    String url =
        "http://190.145.98.43:75/stop-covid/database/recibir.php?action=respiracion&id=" +
            idDiagnostic;
    return http.post(url, body: file.readAsBytesSync()).then((response) async {
      print(response.request);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Future<bool> sendCoughFile({String filePath, String idDiagnostic}) async {
    File file = File(filePath);
    String url =
        "http://190.145.98.43:75/stop-covid/database/recibir.php?action=tos&id=" +
            idDiagnostic;
    return http.post(url, body: file.readAsBytesSync()).then((response) async {
      print(response.request);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }
}

abstract class DataManager {
  Future<String> registerDiagnostic({Map register});
  Future<bool> sendBreathFile({String filePath, String idDiagnostic});
  Future<bool> sendCoughFile({String filePath, String idDiagnostic});
  Future<String> registerAnswers({Map jsonAnswers});
}
