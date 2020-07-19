import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaaka_device/bloc/connection.dart';

class WeightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: BlocBuilder<ConnectionBloc, ConnectionStatus>(
        builder: (context, status) {
          return Center(
            child: StreamBuilder<double>(
                stream: BlocProvider.of<ConnectionBloc>(context).dataStream,
                builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                  return Text(
                    snapshot.data.floor().toString(),
                    style: TextStyle(fontSize: 24.0),
                  );
                }),
          );
        },
      ),
    );
  }
}
