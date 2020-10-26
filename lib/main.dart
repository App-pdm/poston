import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poston/pages/signin.dart';
import 'package:poston/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/': (context) => SignupPage(),
      '/signin': (context) => SigninPage()
    };
    return MaterialApp(
      title: 'PostON',
      theme: ThemeData(
        fontFamily: 'Metropolis',
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        backgroundColor: Color(0xFFE5E5E5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //themeMode: ThemeMode.dark,
      routes: routes,
      initialRoute: '/',
    );
  }
}
