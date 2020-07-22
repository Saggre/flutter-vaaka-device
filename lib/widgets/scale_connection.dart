import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vaaka_device/bloc/connection.dart';
import 'package:vaaka_device/widgets/theme.dart';

class ScaleConnection extends StatelessWidget {
  final ConnectionStatus connectionStatus;

  const ScaleConnection({Key key, @required this.connectionStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child: Image(
                image: AssetImage('assets/images/scale.png'),
                fit: BoxFit.contain,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: ConnectionText(
                connectionStatus: connectionStatus,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = foodModeColor;

    canvas.drawCircle(Offset(0, 0), 5.0, paint);
    canvas.drawCircle(Offset(20, 0), 5.0, paint);
    canvas.drawRect(Rect.fromPoints(Offset(0, -1), Offset(20, 1)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DisconnectedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.deepOrangeAccent;

    canvas.drawCircle(Offset(0, 0), 5.0, paint);
    canvas.drawCircle(Offset(20, 0), 5.0, paint);
    //canvas.drawRect(Rect.fromPoints(Offset(0, -1), Offset(20, 1)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TareingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = weightModeColor;
    double rot = 3.1415 / 4;
    canvas.drawCircle(Offset(0, 0), 5.0, paint);
    canvas.drawCircle(Offset(20, 0), 5.0, paint);
    canvas.rotate(rot);
    canvas.drawRect(Rect.fromPoints(Offset(0, -1), Offset(11, 1)), paint);
    canvas.rotate(-rot);
    canvas.translate(20, 0);
    canvas.rotate(-3 * rot);
    canvas.drawRect(Rect.fromPoints(Offset(0, -1), Offset(11, 1)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ConnectionText extends StatelessWidget {
  final ConnectionStatus connectionStatus;

  const ConnectionText({Key key, @required this.connectionStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 25,
            child: CustomPaint(
              painter: () {
                if (connectionStatus == ConnectionStatus.connected) {
                  return ConnectedPainter();
                } else if (connectionStatus == ConnectionStatus.tareing) {
                  return TareingPainter();
                }
                return DisconnectedPainter();
              }(),
            ),
          ),
        ),
        Text(
          () {
            if (connectionStatus == ConnectionStatus.connected) {
              return "Connected";
            } else if (connectionStatus == ConnectionStatus.tareing) {
              return "Tareing";
            }
            return "Connecting";
          }(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
