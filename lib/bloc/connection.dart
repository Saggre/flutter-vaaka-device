import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';

enum ConnectionStatus {
  disconnected,
  connected,
  tareing,
}

enum ConnectionBlocEvent {
  connect,
  tare,
}

enum TareIllusionProcedure {
  normal,
  didTare,
}

class TareEvent {
  int startTime;
  double weightPreTare;
  TareIllusionProcedure tareIllusionProcedure = TareIllusionProcedure.normal;

  TareEvent(this.weightPreTare) {
    startTime = new DateTime.now().millisecondsSinceEpoch;
    tareIllusionProcedure = TareIllusionProcedure.didTare;
  }
}

class ConnectionBloc extends Bloc<ConnectionBlocEvent, ConnectionStatus> {
  ConnectionBloc() : super(ConnectionStatus.disconnected);

  final int port = 21212;
  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;
  InternetAddress connectedAddress;
  RawDatagramSocket socket;
  TareEvent tareEvent;

  double _latestWeight = 0.0;
  double _animatedWeight = 0.0;
  final _controller = StreamController<double>();

  Stream<double> get dataStream => _controller.stream;

  @override
  Stream<ConnectionStatus> mapEventToState(ConnectionBlocEvent event) async* {
    switch (event) {
      case ConnectionBlocEvent.connect:
        yield await connect();
        break;
      case ConnectionBlocEvent.tare:
        yield ConnectionStatus.tareing;
        await tare();
        yield ConnectionStatus.connected;
        break;
      default:
        addError(Exception('unhandled event: $event'));
    }
  }

  /// Sends tare command to the scale
  Future<bool> tare() async {
    print("Tareing");
    tareEvent = new TareEvent(_latestWeight);
    final List<int> tareData = utf8.encode('vaaka_tare,' + _latestWeight.toString());
    for (int i = 0; i < 3; i++) {
      socket.send(tareData, connectedAddress, port);
    }

    // Wait for the scale to tare
    await Future.delayed(const Duration(milliseconds: 1000), () {});

    return true;
  }

  /// Broadcasts this device so that the scale can send data to us
  Future<ConnectionStatus> connect() async {
    print("Connecting to device...");

    var broadcastAddress = InternetAddress("255.255.255.255");
    final List<int> broadcastData = utf8.encode('vaaka_broadcast');

    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    socket.broadcastEnabled = true;

    while (true) {
      print("Broadcasting");

      socket.send(broadcastData, broadcastAddress, port);

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

      await Future.delayed(const Duration(milliseconds: 100), () {});
    }
  }

  /// Starts acknowledging data input from the scale
  /// Also creates a fake output stream for the data to appear smoother
  Stream<double> initDataStream() {
    RegExp floatExp = new RegExp(r"^-?\d+\.\d+$");

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

    weightStream.listen((double weight) {
      _latestWeight = weight;

      if (tareEvent != null && tareEvent.tareIllusionProcedure == TareIllusionProcedure.didTare) {
        if ((tareEvent.weightPreTare < 0 && _latestWeight > tareEvent.weightPreTare * 0.5) ||
            (tareEvent.weightPreTare > 0 && _latestWeight < tareEvent.weightPreTare * 0.5) ||
            (new DateTime.now().millisecondsSinceEpoch) - tareEvent.startTime > 10000) {
          tareEvent.tareIllusionProcedure = TareIllusionProcedure.normal;
        }
      }
    });

    // 60hz loop
    Timer timer = Timer.periodic(Duration(microseconds: 16666), (Timer t) {
      if (tareEvent != null && tareEvent.tareIllusionProcedure == TareIllusionProcedure.didTare) {
        _animatedWeight = 0.0;
      } else if (_latestWeight > -0.5 && _latestWeight < 0.5) {
        _animatedWeight = 0.0;
      } else {
        _animatedWeight = _animatedWeight * 0.7 + _latestWeight * 0.3;
      }

      _controller.sink.add(_animatedWeight);
    });
  }

  @override
  Future<Function> close() {
    socket.close();
  }
}
