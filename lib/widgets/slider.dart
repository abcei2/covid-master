import 'package:covid/Prediagnostico/ui/screens/homePrediagnostico.dart';
import 'package:covid/main.dart';
import 'package:covid/services/database_helper.dart';
import 'package:covid/widgets/welcome_page.dart';
import 'package:covid/widgets/widget_view_politica.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission/permission.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class IntroScreen extends StatefulWidget {
  @override
  State createState() {
    return new IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  bool _loading;
  bool _showSlider;

  List<Slide> slides = new List();
  final LocalStorage storage = new LocalStorage('covid_u');

  Function goToTab;

  requestPermissions() async {
    List<PermissionName> permissionNames = [];
    permissionNames.add(PermissionName.Camera);
    permissionNames.add(PermissionName.Storage);
    permissionNames.add(PermissionName.Microphone);
    permissionNames.add(PermissionName.Location);
    await Permission.requestPermissions(permissionNames);
  }

  void init() {
    slides.add(
      new Slide(
        title: "QUEDATE EN CASA",
        backgroundColor: Colors.white,
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        widgetDescription: widgetSlideStepOne(),
        styleDescription: TextStyle(
            color: Colors.grey[850],
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/img/quarantine.png",
      ),
    );
    slides.add(
      new Slide(
        title: "VIRUS",
        backgroundColor: Colors.white,
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        widgetDescription: widgetSlideStepTwo(),
        styleDescription: TextStyle(
            color: Colors.grey[850],
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/img/virus.png",
      ),
    );
    slides.add(
      new Slide(
        title: "RECOMENDACIONES",
        backgroundColor: Colors.white,
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        widgetDescription: widgetSlideStepThree(),
        styleDescription: TextStyle(
            color: Colors.grey[850],
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/img/wash-your-hands.png",
      ),
    );
  }

  @override
  void initState() {
    storage.setItem('flag', false);
    requestPermissions();
    init();
    loadPage();
    super.initState();
  }

  Future<void> loadPage() async {
    var db = new DatabaseHelper();
    setState(() {
      _loading = true;
    });
    var user = await db.getUserId(1);
    _showSlider = user == null ? true : user.id == null;
    setState(() {
      _loading = false;
    });
  }

  onDonePress() async {
    var db = new DatabaseHelper();

    await db.getUserId(1).then((value) {
      if (value == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    WidgetViewPolitica(flagRoute: true)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePrediagnostico()));
      }
    });
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget widgetSlideStepOne() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Text(
              '\u2022 ¡Recuerda quedarte en casa! Protege tu salud, y la de tus seres queridos.\n\n'
              '\u2022 Evita visitar espacios públicos con aglomeración de personas. Evita reuniones sociales.\n\n'
              '\u2022 Respeta el distanciamiento físico cuando estés en lugares públicos. Cuenta 2 metros de distancia entre persona y persona. Puedes dar 2 pasos grandes alejándote de la otra persona.',
              textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget widgetSlideStepTwo() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Text(
              '\u2022 Entiende que los síntomas varían mucho entre cada paciente. ¡Ante presencia de la menor sintomatología, quédate en casa!.\n\n'
              '\u2022 Recuerda hacer uso del tapabocas de forma permanente. Recuerda que un uso correcto incluye cubrir tanto boca como nariz.\n\n'
              '\u2022 Evita tocar tu tapabocas y tu cara con las manos. Retíralo únicamente cuando ya estés en casa.\n\n'
              '\u2022 Si tienes un tapabocas de tela, recuerda la importancia de lavarlo regularmente.\n\n'
              '\u2022 Cuando vayas a estornudar o a toser, cúbrete la boca con tu codo doblado o usa un pañuelo y bótalo de inmediato.\n\n'
              '\u2022 Debes reconocer que los jóvenes también están en riesgo de contraer el virus y enfermarse gravemente.',
              textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget widgetSlideStepThree() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Text(
              '\u2022 Higieniza tus manos de manera constante con alcohol o gel.\n\n'
              '\u2022 Lava tus manos con agua y jabón al menos cada 3 horas. Puedes hacer uso de alarmas para no olvidarlo.\n\n'
              '\u2022 Implementa una limpieza y desinfección en tu hogar y sitio de trabajo.\n\n'
              '\u2022 Emplea una rutina de ejercicio de acuerdo con tus capacidades físicas.',
              textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.white,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.white,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      if ((slides.length - 1) == i) {
        tabs.add(Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
            child: ListView(
              children: <Widget>[
                Container(
                  child: Text(
                    currentSlide.title,
                    style: currentSlide.styleTitle,
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  child: Text(
                    currentSlide.description,
                    style: currentSlide.styleDescription,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
                ),
                Center(
                  child: MyStatefulWidget(),
                ),
              ],
            ),
          ),
        ));
      } else {
        tabs.add(Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
            child: ListView(
              children: <Widget>[
                Container(
                  child: Text(
                    currentSlide.title,
                    style: currentSlide.styleTitle,
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  child: Text(
                    currentSlide.description,
                    style: currentSlide.styleDescription,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
                ),
                GestureDetector(
                    child: Image.asset(
                  currentSlide.pathImage,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                )),
              ],
            ),
          ),
        ));
      }
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold()
        : _showSlider
            ? WelcomePage(
                slider: IntroSlider(
                slides: this.slides,
                isShowSkipBtn: false,
                renderNextBtn: this.renderNextBtn(),
                renderDoneBtn: this.renderDoneBtn(),
                onDonePress: this.onDonePress,
                colorDoneBtn: Colors.black,
                highlightColorDoneBtn: Colors.grey[850],
                colorDot: Colors.black,
                sizeDot: 13.0,
                typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
                backgroundColorAllSlides: Colors.white,
                refFuncGoToTab: (refFunc) {
                  this.goToTab = refFunc;
                },
                shouldHideStatusBar: true,
                onTabChangeCompleted: this.onTabChangeCompleted,
              ))
            : HomePrediagnostico();
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _isSelected = false;
  final LocalStorage storage = new LocalStorage('covid_u');

  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Acepto el tratamiento de datos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: _isSelected,
      onChanged: (bool newValue) {
        setState(() {
          storage.setItem('flag', newValue);
          _isSelected = newValue;
        });
      },
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PopupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Alert with Button'),
              onPressed: () => _onAlertButtonPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}

_onAlertButtonPressed(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "ALERT",
    desc: "Debes aceptar el tratamiento de datos.",
    buttons: [
      DialogButton(
        child: Text(
          "Cerrar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}
