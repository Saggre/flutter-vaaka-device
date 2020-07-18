import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';

enum DataBlocEvent { connect }

class DataBloc extends Bloc<DataBlocEvent, int> {
  final Socket channel;

  DataBloc(this.channel) : super(0);

  @override
  Stream<int> mapEventToState(DataBlocEvent event) async* {
    switch (event) {
      case DataBlocEvent.connect:
        yield await connect();
        break;
      default:
        addError(Exception('unhandled event: $event'));
    }
  }

  Future<int> connect() {
    channel.write("test");
  }

  @override
  Future<Function> close() {
    channel.close();
  }
}
