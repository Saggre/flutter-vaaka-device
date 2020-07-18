import 'package:flutter/material.dart';

/// Class for calling code on startup
class StartupCaller extends StatefulWidget {
  final Function init;
  final Widget child;

  const StartupCaller({@required this.init, @required this.child});

  @override
  _StartupCallerState createState() => _StartupCallerState();
}

class _StartupCallerState extends State<StartupCaller> {
  @override
  void initState() {
    if (widget.init != null) {
      widget.init();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
