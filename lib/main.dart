import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poston/pages/map.dart';
import 'package:poston/pages/signin.dart';
import 'package:poston/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PostOn());
}

class PostOn extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/': (context) => SignupPage(),
      '/map': (context) => Map(),
      '/signin': (context) => SigninPage()
    };

    return MaterialApp(
      title: 'PostON',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      initialRoute: '/',
    );
  }
}
