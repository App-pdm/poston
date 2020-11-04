import 'package:flutter/material.dart';
import 'package:poston/pages/map.dart';

void main() {
  runApp(PostOn());
}

class PostOn extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/map': (context) => Map(),
    };

    return MaterialApp(
      title: 'PostON',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      initialRoute: '/map',
    );
  }
}

