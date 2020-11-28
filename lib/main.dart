import 'package:flutter/material.dart';
import 'package:poston/pages/forgot_password.dart';
import 'package:poston/pages/signin.dart';
import 'package:poston/pages/signup.dart';
import 'package:poston/pages/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PostOn());
}

class PostOn extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = {
      '/': (context) => SigninPage(),
      '/signup': (context) => SignupPage(),
      '/forgot': (context) => ForgotPasswordPage(),
      '/start': (context) => StartPage(),
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
