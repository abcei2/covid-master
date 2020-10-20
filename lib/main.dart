import 'dart:io';
import 'package:covid/Prediagnostico/ui/screens/homePrediagnostico.dart';
import 'package:covid/Prediagnostico/ui/screens/results.dart';
import 'package:covid/services/sync_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/size_config.dart';
import 'widgets/slider.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Simple check to see if we have internet
  print("The statement 'this machine is connected to the Internet' is: ");
  print(await DataConnectionChecker().hasConnection);
  // returns a bool

  // We can also get an enum instead of a bool
  print("Current status: ${await DataConnectionChecker().connectionStatus}");
  // prints either DataConnectionStatus.connected
  // or DataConnectionStatus.disconnected

  // This returns the last results from the last call
  // to either hasConnection or connectionStatus
  print("Last results: ${DataConnectionChecker().lastTryResults}");

  // actively listen for status updates
  DataConnectionChecker().onStatusChange.listen((status) async {
    switch (status) {
      case DataConnectionStatus.connected:
        syncData();
        //await syncData2();
        print('Con internet');
        break;
      case DataConnectionStatus.disconnected:
        print('Sin internet');
        break;
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('es', ''),
        ],
        title: "Stop Covid",
        debugShowCheckedModeBanner: false,
        home: IntroScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new HomePrediagnostico(),
          '/results': (BuildContext context) => new Results()
        },
      );
    });
  }
}
