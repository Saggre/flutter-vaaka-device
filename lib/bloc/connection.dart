import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';

enum ConnectionStatus {
  disconnected,
  deviceFound,
  connected,
}

enum ConnectionBlocEvent {
  connect,
}

class ConnectionBloc extends Bloc<ConnectionBlocEvent, ConnectionStatus> {
  ConnectionBloc() : super(ConnectionStatus.disconnected);

  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;
  Socket socket;

  @override
  Stream<ConnectionStatus> mapEventToState(ConnectionBlocEvent event) async* {
    switch (event) {
      case ConnectionBlocEvent.connect:
        String deviceIp = await findDevice();
        yield connectionStatus;
        await connect(deviceIp);
        yield connectionStatus;
        break;
      default:
        addError(Exception('unhandled event: $event'));
    }
  }

  Future<bool> connect(String deviceIp) async {
    print("Connecting to device...");
    Socket.connect(deviceIp, 21212, timeout: Duration(seconds: 60))
        .then((value) {
      socket = value;
      socket.write("Connect");
      connectionStatus = ConnectionStatus.connected;
      print("Connected to device");
    }).catchError((error) {
      connectionStatus = ConnectionStatus.disconnected;
      print("Error connecting to device: " + error.toString());
    });

    return true;
  }

  /// Finds the device based on received UDP packets
  Future<String> findDevice() async {
    RawDatagramSocket datagramSocket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 21212);

    /// Receive response
    await for (RawSocketEvent evt in datagramSocket.asBroadcastStream()) {
      if (evt == RawSocketEvent.read) {
        Datagram packet = datagramSocket.receive();
        String dataString = new String.fromCharCodes(packet.data);

        if (dataString == "vaaka") {
          InternetAddress sender = packet.address;
          print("Found device at: " + sender.address);

          // Stop listening and close the socket
          datagramSocket.close();
          connectionStatus = ConnectionStatus.deviceFound;
          return sender.address;
        }
      }
    }
  }

  @override
  Future<Function> close() {
    socket.close();
  }
}
