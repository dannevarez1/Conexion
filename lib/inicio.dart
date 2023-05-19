import 'package:conexion/principalbluetooth.dart';
import 'package:conexion/wificonexion.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MiInicio();
  }
}

class MiInicio extends State <Inicio> {
  int _selectedIndex = 0;
  final List <Widget> _children = [
    PrincipalPage(),
    WifiConexion()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black12,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.bluetooth),
              label: 'Bluetooth'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              label: 'Wifi'
          ),
        ],
      ),
    );
  }
}