import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaaka_device/pages/weight.dart';
import 'package:vaaka_device/widgets/startup_caller.dart';
import 'package:vaaka_device/widgets/theme.dart';
import 'bloc/SimpleBlocObserver.dart';
import 'bloc/connection.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConnectionBloc connectionBloc = ConnectionBloc();

    return MaterialApp(
      title: 'Scale',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: textColor,
          ),
          bodyText2: TextStyle(
            color: textColor,
          ),
        ),
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartupCaller(
        init: () async {
          print("Init");
          connectionBloc.add(ConnectionBlocEvent.connect);
        },
        child: BlocProvider<ConnectionBloc>(
          create: (context) => connectionBloc,
          child: WeightPage(),
        ),
      ),
    );
  }
}
