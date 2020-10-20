import 'package:covid/services/database_helper.dart';
import 'package:covid/widgets/button_purple.dart';
import 'package:covid/User/ui/screens/registerUserPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:covid/User/ui/screens/registerUser.dart';

import 'cellular_data_usage_dialog.dart';

class WidgetViewPolitica extends StatefulWidget {
  final bool flagRoute;

  WidgetViewPolitica({Key key, @required this.flagRoute});

  @override
  _WidgetViewPolitica createState() => _WidgetViewPolitica();
}

class _WidgetViewPolitica extends State<WidgetViewPolitica> {
  final _controllerNameUser = TextEditingController();
  final _controllerNumberIdentification = TextEditingController();
  var name;
  var typeIdentification;
  var numberIdentification;
  var db = new DatabaseHelper();

  final LocalStorage storage = new LocalStorage('covid_u');
  bool _isSelectedAccepted = false;
  bool _isSelectedNotAccepted = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showCellularDataUsageDialog());
    this.typeIdentification = 'Cédula de ciudadanía';
    storage.deleteItem('flagNotAccepted');
    storage.setItem('flagAccepted', false);
    super.initState();
  }

  void showCellularDataUsageDialog() {
    showDialog(
        context: context,
        child: CellularDataUsageDialog(),
        barrierDismissible: false);
  }

  _WidgetViewPolitica() {
    storage.deleteItem('numberTmp');
    storage.deleteItem('nameTmp');
  }
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    int _radioValue1 = -1;

    return Scaffold(
        appBar: AppBar(
          title: Text("Politicas de privacidad"),
          backgroundColor: Color.fromRGBO(76, 162, 211, 1.0),
          automaticallyImplyLeading: true,
          /*leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )*/
        ),
        //drawer: MenuLateral('usuarios'),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Container(
                  margin: EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Text(
                            'DECLARACIÓN DE USO DE DATOS PERSONALES',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          )),
                      Text(
                          'El centro de investigaciones “Corporación  para  Investigaciones  Biológicas” (CIB), en cabeza del investigador principal Enrique León y con motivo de la convocatoria realizada por  el  Ministerio  de    Ciencia,  Tecnología  e  Innovación  (CTeI),  está  desarrollando  un Sistema Telemático de Prediagnóstico Personal de Síntomas reconocidos de COVID-19(STOP COVID),  cuyo objetivo es contribuir al uso eficiente de los recursos de atención de  salud  durante  la  pandemia  de  COVID-19,  a  través  de  una  plataforma  móvil  que permita  un  prediagnóstico  masivo  de  forma  remota.  STOP  COVID  se  trata  de  una aplicación que tendrá la capacidad de recolectar datos públicos, semiprivados, privados y sensibles de voluntarios que deseen participar.  Con el fin de proteger la privacidad de los  participantes,  dichos  datos  serán  codificados  y  custodiados  por  el  investigador principal y su equipo, y serán usados exclusivamente para promover la investigación en torno  al  SARS-CoV-2  buscando  contener  y  prevenir  contagios  masivos.  Bajo  ningún suceso su información personal será revelada, con única excepción ante una situación que ponga en riesgo su vida o la de los otros participantes, en cuyo caso los implicados serían consultados previamente.\n\nCon los datos suministrados por usted, lograremos:',
                          textAlign: TextAlign.justify),
                      Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          children: [
                            Text(
                                '1. Crear  perfiles  de  personas  que  serán  pre-diagnosticadas  a  través  de  nuestra aplicación.',
                                textAlign: TextAlign.justify),
                            Text(
                                '2. Permitir a los usuarios ingresar a la app y hacer uso de las funcionalidades propias de ella.',
                                textAlign: TextAlign.justify),
                            Text(
                                '3. Realizar un pre-diagnóstico de COVID19 a partir de un algoritmo inteligente por medio de una grabación de la tos, la respiración y del ritmo cardiaco.',
                                textAlign: TextAlign.justify),
                            Text(
                                '4. Monitorear síntomas, signos de alarma de infección respiratoria y riesgos para la salud pública asociados al COVID-19.',
                                textAlign: TextAlign.justify),
                            Text(
                                '5. Acceder  a  la  geolocalización  de  usuarios  y  la  ubicación  del  dispositivo  para despliegue de esfuerzos de diagnóstico.',
                                textAlign: TextAlign.justify),
                            Text(
                                '6. Acceder  al micrófono  para  capturar  los  datos  necesarios  para  que  el  algoritmo inteligente instalado en la app tenga la capacidad de hacer un pre-diagnóstico de posible contagio del covid-19.',
                                textAlign: TextAlign.justify),
                            Text(
                                '7. Enviar desde la app a un servicio web los datos suministrados por el usuariopara poder  tener  un  sistema  unificado  de  las  alertas  de  posible  contagio  de  la comunidad  para  que  los  entes  de  salud  puedan  crear  estrategias  que  permita contener el virus y permitirles a los usuarios hacer protocolos seguros para cuidar su  salud.No  significa  que  se  vayan  a  divulgar  sus  datos,  su  información  será totalmente anonimizada.',
                                textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'SOBRE EL TRATAMIENTO DE DATOS',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                                '8. Los datos suministrados serán tratados conforme a lo dispuesto en la Ley 1581 de 2012 y sus decretos reglamentarios.',
                                textAlign: TextAlign.justify),
                            Text(
                                '9. La persona que usa este pre-diagnóstico asume toda la responsabilidad sobre el buen uso de la app y se compromete a proporcionar la información de forma fiable.',
                                textAlign: TextAlign.justify),
                            Text(
                                '10. De conformidad con lo establecido en la Ley 1581 de 2012 de protección de datos personales, se podrá suministrar información a las entidades públicas (Secretarías Departamentales y Municipales de Salud, y Ministerio de Salud)o administrativas (Instituto Nacional de Salud) que en el ejercicio de sus  funciones legales así lo requieran, o a las personas establecidas en el artículo 13 de la ley.',
                                textAlign: TextAlign.justify),
                            Text(
                                '11. La información personal a la que acceden las Entidades es obtenida directamente del usuario a partir de su registro o a través de la consulta de bases de datos de fuentes oficiales.',
                                textAlign: TextAlign.justify),
                            Text(
                                '12. Los datos proporcionados por el usuario deben ser veraces, completos, exactos, actualizados,  comprobables  y  comprensibles  y,  en  consecuencia,  el  usuario asume toda la responsabilidad sobre la falta de veracidad o exactitud de éstos.',
                                textAlign: TextAlign.justify),
                            Text(
                                '13. Si  tiene  alguna  duda  sobre  el  uso  de  sus  datos  o  desea  conocer,  actualizar  y rectificar su información, por favor póngase en contacto con eleon@cib.org.co.',
                                textAlign: TextAlign.justify),
                            Text(
                                '14. Recuerde que usted tiene el derecho de retirarse del estudio y solicitar la total o parcial destrucción de sus datos cuando así lo desee, sin repercusión alguna.',
                                textAlign: TextAlign.justify),
                            Text(
                                '15. Los datos de la totalidad de los participantes serán destruidos en un término de 2 años después de finalizado el proyecto.',
                                textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'SOBRE EL PRE-DIAGNÓSTICO',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                                '16. El uso de este aplicativo está restringido a personas mayores de edad sin ninguna discapacidad física o intelectual conocida.',
                                textAlign: TextAlign.justify),
                            Text(
                                '17. El resultado de este pre-diagnóstico es orientativo y sirve para poder asesorar a la persona con información preliminar de un posible contagio de COVID19 y por lo tanto NO sustituye una prueba de laboratorio.',
                                textAlign: TextAlign.justify),
                            Text(
                                '18. El resultado de este pre-diagnóstico NO tiene ninguna validez legal para demostrar que una persona está o no contagiada con COVID19 y debe seguirse siempre el protocolo de atención recomendado por las autoridades de salud en caso de sospecha y/o prevención de contagio.',
                                textAlign: TextAlign.justify),
                            Text(
                                '19. Este pre-diagnóstico bajo ninguna circunstancia exime a una persona de seguir las indicaciones de las autoridades de salud, de seguridad pública o cualquier otro organismo público o privado designado por los gobiernos municipales, departamentales o nacionales para atender la pandemia de COVID19.',
                                textAlign: TextAlign.justify),
                            Text(
                                '20. Independientemente del resultado del pre-diagnóstico, si por alguna razón tiene sospecha fundada de que usted o alguna persona cercana a usted han estado expuestas o han sido contagiadas de COVID19, no dude en contactar a la autoridad de salud más cercana a través del formulario de la app o visitando www.sitioinfo.com.',
                                textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          'Entiendo que el procedimiento de recolección de datos involucra el uso de un micrófono en un dispositivo electrónico, además de datos personales sobre mi historial clínico. También se me ha informado que ello no genera efectos secundarios, colaterales ni complicaciones, o existencia de riesgos médicos físicos ni mentales. Se me han resuelto las dudas que me surgieron durante la entrevista.\n',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Dejo constancia de que he leído sobre el derecho que me asiste de rechazar la realización del procedimiento y actividad, y he entendido que este documento es legal, sustentado bajo el principio de autonomía, consagrado en la Constitución Política de Colombia y Códigos de ética de cada Profesión de la Salud estipulada de la siguiente manera: Medicina: Ley 23 de 1981, capítulos I,II,III. Enfermería: Ley 911 de 2004 Bacteriología: Ley 841 de 2003, Título I,IV. Terapia Respiratoria: Ley 1240 de 2008 título I, así como de la norma de manejo de la Historia Clínica Resolución 1995 de 1999 y la Resolución 13437 de 1991, donde se adopta el Decálogo de Derechos de los Pacientes. Así mismo comprendo sobre el tratamiento y derechos del uso de mis datos personales de acuerdo con la ley 1581 de 2012.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'Por lo anterior, autorizo al personal responsable del proyecto STOPCOVID y a la Corporación para Investigaciones Biológicas (CIB) para que se me realice el procedimiento de recolección de datos.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      /*   LabeledCheckbox(
                            label:
                                'Estoy de acuerdo y acepto participar en el presente estudio y utilizar esta aplicación para realizar un pre-diagnóstico de COVID19.',
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            value: _isSelectedAccepted,
                            onChanged: (bool newValue) {
                              storage.setItem('flagAccepted', newValue);
                              setState(() {
                                _isSelectedAccepted = newValue;
                              });
                            },
                          ), */
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'NO ACEPTACIÓN: En consideración a la información recibida y descrita anteriormente he tomado la decisión de NO ACEPTAR, RECHAZAR Y NO AUTORIZAR la actividad declarando que he sido instruido amplia y suficientemente sobre las posibles consecuencias de mi participación en este proyecto.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      /*   LabeledCheckbox(
                            label:
                                'No estoy de acuerdo y no deseo participar en el presente estudio.',
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            value: _isSelectedNotAccepted,
                            onChanged: (bool newValue) {
                              storage.setItem('flagNotAccepted', newValue);
                              setState(() {
                                _isSelectedNotAccepted = newValue;
                              });
                            },
                          ), */
                      Row(
                        children: [
                          Text('Yo '),
                          Expanded(
                            child: SizedBox(
                              // height: 200.0,
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 5.0,
                                      bottom: 5.0,
                                      top: 0.0,
                                      right: 0.0),
                                  child: TextField(
                                      inputFormatters: [
                                        new FilteringTextInputFormatter.allow(
                                            RegExp("[A-Za-zÁÉÍÓÚáéíóúñÑ ]")),
                                      ],
                                      //onChanged: onchanged,
                                      controller: _controllerNameUser,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(0),
                                        isDense: true,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue),
                                        ),
                                      ),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Lato',
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ],
                      ),
                      Text.rich(
                          TextSpan(children: <TextSpan>[
                            TextSpan(text: 'identificado con la '),
                            TextSpan(
                                text: 'Cédula de ciudadanía',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                )),
                            TextSpan(text: ' número:'),
                          ]),
                          textAlign: TextAlign.justify),
                      Container(
                        margin:
                            EdgeInsets.only(left: 0.0, right: 0.0, bottom: 5.0),
                        child: TextField(
                          controller: _controllerNumberIdentification,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Lato',
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _myRadioButton(
                                title: "Acepto",
                                value: 0,
                                onChanged: (newValue) {
                                  storage.setItem('flagAccepted', true);
                                  storage.setItem('flagNotAccepted', false);
                                  setState(() => _groupValue = newValue);
                                }),
                            Text('Acepto'),
                            _myRadioButton(
                                title: "No acepto",
                                value: 1,
                                onChanged: (newValue) {
                                  storage.setItem('flagAccepted', false);
                                  storage.setItem('flagNotAccepted', true);
                                  setState(() => _groupValue = newValue);
                                }),
                            Text('No acepto'),
                          ],
                        ),
                      ),
                      Container(
                        width: 400.0,
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: ButtonPurple(
                          buttonText: 'Ingresar',
                          onPressed: () async {
                            var flagAccepted = storage.getItem('flagAccepted');
                            var flagNotAccepted =
                                storage.getItem('flagNotAccepted');

                            if (flagAccepted == false ||
                                flagNotAccepted == true) {
                              _onAlertButtonPressed(context,
                                  'Debes estar de acuerdo con nuestras políticas para poder registrarse en la aplicación');
                              return;
                            }

                            if (_controllerNameUser.text == null ||
                                _controllerNameUser.text == '') {
                              _onAlertButtonPressed(
                                  context, 'El nombre es obligatorio');
                              return;
                            }

                            if (_controllerNumberIdentification.text == null ||
                                _controllerNumberIdentification.text == '') {
                              _onAlertButtonPressed(context,
                                  'El número de identificación es obligatorio');
                              return;
                            }

                            storage.setItem('nameTmp', _controllerNameUser.text);
                            storage.setItem('numberTmp',
                                _controllerNumberIdentification.text);
                            if (widget.flagRoute == true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterUserPrincipal()));
                            } else if (widget.flagRoute == false) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterUser()));
                            }
                          },
                        ),
                      )
                    ],
                  )),
            )));
  }

  _onAlertButtonPressed(context, msg) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Información",
      desc: msg,
      buttons: [
        DialogButton(
          child: Text(
            "Cerrar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // onPressed: () => Navigator.pop(context, false),
          width: 120,
        )
      ],
    ).show();
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return Radio(
      value: value,
      groupValue: this._groupValue,
      onChanged: onChanged,
      //title: Text(title),
    );
  }
}
