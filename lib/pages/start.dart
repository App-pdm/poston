import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:poston/pages/gas_station.dart';
import 'package:poston/pages/profile.dart';
import 'package:poston/pages/map.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);
  @override
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    GasSationList(),
    MapPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: bottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationBar() {
    return Container(
      height: 83,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 35,
              ),
              label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_outlined,
              size: 35,
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 35,
            ),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFDB3022),
        onTap: _onItemTapped,
      ),
    );
  }
}
