import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class WifiPage extends StatefulWidget {
  final String ip;

  WifiPage({required this.ip});

  @override
  State<StatefulWidget> createState() {
    return MyWifiPage();
  }
}

class MyWifiPage extends State<WifiPage> {
  late StreamController<String> _streamController;
  late Stream<String> _stream;
  late Socket socket;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    _stream = _streamController.stream;
    _conexion();
  }

  void _conexion() async {
    socket = await Socket.connect(widget.ip, 80);
    socket.listen((event) {
      String dato = utf8.decode(event);
      _streamController.add(dato);
    }, onError: (error) {
      print('$error');
    }, onDone: () {
      print('Se ha desconectado');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Conexión Wifi"),
          backgroundColor: Colors.red,
        ),
        body: Container(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        child: Text("Prender"),
                        onPressed: () {
                          prender();
                        }),
                    ElevatedButton(
                        child: Text("Apagar"),
                        onPressed: () {
                          apagar();
                        }),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          StreamBuilder(
                              stream: _stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.active) {
                                  if (snapshot.hasData) {
                                    return Text('${snapshot.data}');
                                  }
                                } else if (snapshot.connectionState == ConnectionState.waiting) {
                                  return ElevatedButton(
                                      onPressed: () {

                                      },
                                      child: Text('Intentar Conexión'));
                                }
                                return Text('data');
                              })
                        ])
                  ])),
        ));
  }
  void prender() {
    socket.write("p\n");
  }
  void apagar() {
    socket.write("a\n");
  }
  @override
  void dispose() {
    socket.close();
    super.dispose();
  }
}