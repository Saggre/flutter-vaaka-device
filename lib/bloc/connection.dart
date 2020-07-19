import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';

enum ConnectionStatus {
  disconnected,
  connected,
}

enum ConnectionBlocEvent {
  connect,
}

class ConnectionBloc extends Bloc<ConnectionBlocEvent, ConnectionStatus> {
  ConnectionBloc() : super(ConnectionStatus.disconnected);

  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;
  InternetAddress connectedAddress;
  RawDatagramSocket socket;

  final _controller = StreamController<double>();

  Stream<double> get dataStream => _controller.stream;

  @override
  Stream<ConnectionStatus> mapEventToState(ConnectionBlocEvent event) async* {
    switch (event) {
      case ConnectionBlocEvent.connect:
        yield await connect();
        break;
      default:
        addError(Exception('unhandled event: $event'));
    }
  }

  Future<ConnectionStatus> connect() async {
    print("Connecting to device...");

    var broadcastAddress = InternetAddress("255.255.255.255");
    List<int> broadcastData = utf8.encode('vaaka_broadcast');

    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 21212);
    socket.broadcastEnabled = true;

    while (true) {
      print("Broadcasting");

      socket.send(broadcastData, broadcastAddress, 21212);

      Datagram packet = socket.receive();
      if (packet != null) {
        String dataString = new String.fromCharCodes(packet.data);
        if (dataString == "vaaka_acknowledged") {
          connectedAddress = packet.address;
          print("Found device at: " + connectedAddress.toString());
          initDataStream();
          return ConnectionStatus.connected;
        }
      }

      sleep(const Duration(milliseconds: 500));
    }
  }

  Stream<double> initDataStream() {
    RegExp floatExp = new RegExp(r"^-?\d+\.\d+$");

    double last;

    Stream<double> weightStream = socket
        .asBroadcastStream()
        .map((event) {
          Datagram packet = socket.receive();
          if (packet != null) {
            return new String.fromCharCodes(packet.data);
          }

          return "";
        })
        .where((String dataString) => floatExp.hasMatch(dataString))
        .map((String dataString) {
          double weight = double.parse(dataString);
          return weight;
        });

    double latestWeight = 0.0;
    double animatedWeight = 0.0;

    weightStream.listen((double weight) {
      latestWeight = weight;
    });

    // 60hz loop
    Timer timer = Timer.periodic(Duration(microseconds: 16666), (Timer t) {
      animatedWeight = animatedWeight * 0.7 + latestWeight * 0.3;
      _controller.sink.add(animatedWeight);
    });
  }

  @override
  Future<Function> close() {
    socket.close();
  }
}
