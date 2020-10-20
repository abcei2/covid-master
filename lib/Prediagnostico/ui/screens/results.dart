import 'package:covid/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Results extends StatefulWidget {
  final nameUser;
  final probability;
  Results({Key, key, this.nameUser, this.probability});
  @override
  _Results createState() {
    return _Results();
  }
}

class _Results extends State<Results> {
  double iconSize = 40;
  double percentage = 0.0;
  bool flag = true;
  int stepCurrent;
  int totalStep;
  final LocalStorage storage = new LocalStorage('covid_u');
  var dataUser;
  var db = new DatabaseHelper();
  var name;
  List _states = [
    {
      'id': 1,
      'name': "Antioquia",
      'lines': [
        {'entidad': 'SURA Poliza', 'numero': '(018000518888 - #8887 opción 0)'},
        {
          'entidad': 'SURA EPS',
          'numero': '(018000519519 - Whatsapp 3024546329)'
        },
        {'entidad': 'Coomeva', 'numero': '018000930779 opción 8'},
        {'entidad': 'Nueva EPS', 'numero': '018000954400 opción 2'},
        {'entidad': 'Savia Salud', 'numero': '018000423683'},
        {'entidad': 'Sanitas', 'numero': '018000919100'},
        {'entidad': 'Medimas', 'numero': '018000120777'},
        {'entidad': 'Salud Total', 'numero': '018000114524'},
        {'entidad': 'Línea general', 'numero': '123'},
      ]
    }
  ];

  String _currentState;
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    super.initState();
  }

  _Results() {}

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (var state in _states) {
      items.add(new DropdownMenuItem(
          value: state['id'].toString(), child: new Text(state['name'])));
    }
    return items;
  }

  //var list;
  var list;
  var itemsL;

  void changedDropDownItem(selectedState) {
    /*   var p = _states.where((element) {
      return element;
    });
 */
// int index = _states.indexWhere(test);
    // var p = _states.where((element) => element["id"] == selectedState);
    // var p = _states.firstWhere((element) => element['id'] == selectedState);
    var p;
    for (var i = 0; i < _states.length; i++) {
      if (_states[i]['id'] == int.parse(selectedState)) {
        p = _states[i];
      }
    }
    List<Widget> it = new List();
    for (var d in p['lines']) {
      it.add(Text("${d['entidad']}:", style: TextStyle(fontWeight: FontWeight.w600),));
      it.add(Text("Teléfono(s): ${d['numero']}", textAlign: TextAlign.justify));
      it.add(Divider());
    }
    var it2 = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: it,
    );

    setState(() {
      itemsL = it2;
      _currentState = selectedState;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    print('----- arguments');
    print(arguments);
    print('----- arguments');
    var content = Container(
        margin: EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
        child: Column(
          children: [
            Text(
              'Líneas de atención',
              style: TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
            Container(
              child: new DropdownButton(
                value: _currentState,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                child: itemsL),
            /*         ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: itemsL), */
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Indicaciones a seguir'),
        backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
        automaticallyImplyLeading: true,
      ),
      body: Stack(
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
          SingleChildScrollView(
            child: Container(
                width: screenWidth,
                margin: EdgeInsets.only(top: 15.0),
                child: Center(
                    child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 25.0),
                    child: Column(
                      children: [
                        Text("${arguments['probability']}",
                            style: TextStyle(
                                fontSize: 25,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue)),
                        SizedBox(height: 10),
                        Text(
                          'Recomendaciones',
                          style: TextStyle(fontSize: 20),
                        ),
                        if (arguments['probability'] == 'NO CONTAGIO')
                          Container(
                            margin: EdgeInsets.only(
                                top: 15.0, right: 15.0, left: 15.0),
                            child: Column(children: [
                              Text(
                                  'Tus síntomas y variables no parecen coincidir con un contagio de SARS-CoV-2 (COVID-19). Sin embargo, recuerda que se trata de una enfermedad que nos puede afectar a todos. Continúa haciendo uso de tapabocas, lavar tus manos cada 3 horas, practica el distanciamiento social y evita frecuentar sitios con aglomeraciones.'
                                  '\n\nDebes estar atento ante cualquier síntoma compatible con SARS-CoV-2 como: tos, fiebre, dolor de cabeza, dolor de garganta, dolor en tórax o abdomen, náuseas, vómito o diarrea, pérdida del gusto o pérdida del olfato.',
                                  textAlign: TextAlign.justify)
                            ]),
                          )
                        else if (arguments['probability'] ==
                            'PROBABILIDAD BAJA')
                          Container(
                            margin: EdgeInsets.only(
                                top: 15.0, right: 15.0, left: 15.0),
                            child: Column(children: [
                              Text(
                                  'Tienes una probabilidad baja de presentar COVID19, enfermedad causada por el virus SARS-CoV-2. Sin embargo, recuerda que se trata de una enfermedad que nos puede afectar a todos. Continúa haciendo uso de tapabocas, lavar tus manos cada 3 horas, practica el distanciamiento social y evita frecuentar sitios con aglomeraciones.'
                                  '\n\nDebes estar atento ante cualquier síntoma compatible con SARS-CoV-2 como: tos, fiebre, dolor de cabeza, dolor de garganta, dolor en tórax o abdomen, náuseas, vómito o diarrea, pérdida del gusto o pérdida del olfato.',
                                  textAlign: TextAlign.justify)
                            ]),
                          )
                        else if (arguments['probability'] ==
                            'PROBABILIDAD MEDIA')
                          Container(
                            margin: EdgeInsets.only(
                                top: 15.0, right: 15.0, left: 15.0),
                            child: Column(children: [
                              Text(
                                  'Tienes una probabilidad media de presentar COVID19, enfermedad causada por el virus SARS-CoV-2. Debes estar atento ante cualquier cambio o empeoramiento de los siguientes síntomas: dificultad para respirar durante labores que antes realizabas sin problemas (barrer, trapear, hacer aseo, vestirte, etc.), tos seca que te ahoga o te produce vómito o fiebre que no mejora con medicamentos. En este caso debes consultar a tu EPS.'
                                  '\n\nRecuerda seguir aplicando las medidas de seguridad como continuar haciendo uso de tapabocas, lavar tus manos cada 3 horas, practica el distanciamiento social y evita frecuentar sitios con aglomeraciones.',
                                  textAlign: TextAlign.justify)
                            ]),
                          )
                        else if (arguments['probability'] ==
                            'PROBABILIDAD ALTA')
                          Container(
                            margin: EdgeInsets.only(
                                top: 15.0, right: 15.0, left: 15.0),
                            child: Column(children: [
                              Text(
                                  'Tienes una alta probabilidad de presentar COVID19, enfermedad causada por el virus SARS-CoV-2. Debes consultar por urgencias o comunicarte con la línea del 123 en caso de presentar: dificultad para respirar incluso cuando estás en reposo, si te pita el pecho al respirar, si se te hunden las costillas o el cuello cuando respiras, si tus labios se tornan morados.'
                                  '\n\nEn caso de que hayas recibido un COVID-kit por parte de tu EPS, que incluye un termómetro y un dispositivo para medir el oxígeno, recuerda usarlos frecuentemente y estar atento a presentar una temperatura mayor a 38 grados y un nivel de oxígeno menor a 90%.'
                                  '\n\nRecuerda seguir aplicando las medidas de seguridad como continuar haciendo uso de tapabocas, lavar tus manos cada 3 horas, practica el distanciamiento social y evita frecuentar sitios con aglomeraciones.',
                                  textAlign: TextAlign.justify)
                            ]),
                          ),
                        Container(
                            margin: EdgeInsets.only(
                                top: 15.0, right: 15.0, left: 15.0),
                            child: Text(
                              'NOTA: Este resultado no descarta ni confirma una infección por SARS-CoV-2, virus causante de la enfermedad COVID 19. Es exclusivamente una guía de probabilidad basada en la información proporcionada por el participante.',
                              textAlign: TextAlign.justify,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, right: 15.0, left: 15.0, bottom: 10.0),
                    child: DialogButton(
                      child: Text(
                        "Finalizar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home', (Route<dynamic> route) => false);
                      },
                      width: 120,
                    ),
                  ),
                  if (true) content,
                ]))),
          ),
        ],
      ),
    );
  }
}
