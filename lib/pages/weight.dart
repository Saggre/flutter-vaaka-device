import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaaka_device/bloc/connection.dart';
import 'package:vaaka_device/widgets/button.dart';
import 'package:vaaka_device/widgets/scale_connection.dart';
import 'package:vaaka_device/widgets/theme.dart';

class WeightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ConnectionBloc, ConnectionStatus>(
          builder: (context, status) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 100,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: StreamBuilder<double>(
                      stream: BlocProvider.of<ConnectionBloc>(context).dataStream,
                      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                        return () {
                          if (status == ConnectionStatus.tareing) {
                            return SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(),
                            );
                          }

                          return Text(
                            snapshot.data?.round().toString() + " g",
                            style: TextStyle(
                              fontSize: 64.0,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }();
                      }),
                ),
                Text(
                  "Current weight",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                ),
                BaseButton(
                  onPress: () {
                    BlocProvider.of<ConnectionBloc>(context).add(ConnectionBlocEvent.tare);
                  },
                  maxWidth: 150,
                  text: "Tare",
                  color: weightModeColor,
                  disabled: status == ConnectionStatus.tareing,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                Text(
                  () {
                    double dt = 0;
                    TareEvent tareEvent = BlocProvider.of<ConnectionBloc>(context).tareEvent;
                    if (tareEvent != null) {
                      dt = tareEvent.weightPreTare;
                    }
                    return "Δtare: " + dt.round().toString() + " g";
                  }(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                ),
                ScaleConnection(
                  connectionStatus: status,
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                    ),
                    Expanded(
                      child: BaseButton(
                        onPress: () {},
                        text: "Change",
                        color: weightModeColor,
                        disabled: status == ConnectionStatus.tareing,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                    ),
                    Expanded(
                      child: BaseButton(
                        onPress: () {},
                        text: "Add to list",
                        color: foodModeColor,
                        disabled: status == ConnectionStatus.tareing,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
