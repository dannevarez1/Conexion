import 'dart:async';
import 'package:conexion/SelectBondedDevicePage.dart';
import 'package:conexion/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PrincipalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyPrincipalPage();
  }
}

class MyPrincipalPage extends State <PrincipalPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _adress = '...';
  String _name = '...';

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;


  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    Future.doWhile(() async {
      if ((await FlutterBluetoothSerial.instance.isEnabled)?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0x00));
      return true;
    }).then((_){
      FlutterBluetoothSerial.instance.address.then((adress) {
        setState(() {
          _adress = adress!;
        });
      });
    });
    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conexión Bluetooth"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: ListView(
          children: <Widget> [
            ListTile(
              title: ElevatedButton(
                child: Text ('Ver dispositivos disponibles'),
                onPressed: () async {
                  final BluetoothDevice? selectedDevice =
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(checkAvailability: false);
                      },
                    ),
                  );
                  if (selectedDevice != null) {
                    print ('Connect -> selected' + selectedDevice.address);
                    _startChat(context, selectedDevice);
                  } else {
                    print ('Connect -> no device selected');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _startChat (BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              return ChatPage(server: server);
            }
        )
    );
  }
}