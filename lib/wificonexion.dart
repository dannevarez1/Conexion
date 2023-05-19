import 'package:conexion/inicio.dart';
import 'package:conexion/wifipage.dart';
import 'package:flutter/material.dart';

class WifiConexion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WifiConexionApp();
  }
}

class WifiConexionApp extends State<WifiConexion> {
  final TextEditingController _controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Direccion IP"),
      content: TextField(
          controller: _controlador,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              icon: Icon(Icons.wifi),
              border: OutlineInputBorder(),
              labelText: "Direccion IP")),
      actions: [
        TextButton(
          onPressed: () {
            if(! _controlador.text.isEmpty){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return WifiPage(ip: _controlador.text);
                  }));
            }
          },
          child: Text("Aceptar"),
        ),
        TextButton(
          onPressed: () {

            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return Inicio();
                }));
          },
          child: Text("Cancelar"),
        )
      ],
    );
  }
}