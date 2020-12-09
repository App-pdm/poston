import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    Container(
      color: Colors.black,
    ),
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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

// Container(
//         height: 83,
//         decoration: BoxDecoration(
//           color: Color(0xFFFFFFFF),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(12),
//             topRight: Radius.circular(12),
//           ),
//         ),
// )
