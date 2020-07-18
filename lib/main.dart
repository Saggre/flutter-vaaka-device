import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaaka_device/pages/weight.dart';
import 'package:vaaka_device/widgets/startup_caller.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
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
