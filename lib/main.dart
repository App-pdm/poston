import 'package:flutter/material.dart';
import 'package:poston/pages/change_name.dart';
import 'package:poston/pages/forgot_password.dart';
import 'package:poston/pages/map.dart';
import 'package:poston/pages/profile.dart';
import 'package:poston/pages/signin.dart';
import 'package:poston/pages/signup.dart';
import 'package:poston/pages/start.dart';
import 'package:poston/pages/fuel.dart';
import 'package:poston/pages/map.dart';

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
      '/profile': (context) => ProfilePage(),
      '/profile/changename': (context) => ChangeNamePage(),
      '/map': (context) => MapPage(),
    };

    return MaterialApp(
      title: 'PostON',
      theme: ThemeData(
          primaryColor: Color(0xFFE5E5E5),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Metropolis"),
      routes: routes,
      initialRoute: '/map',
    );
  }
}
