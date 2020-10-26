import 'package:flutter/material.dart';
import 'package:poston/widgets/containertext.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatelessWidget {
  String _nome;
  String _email;
  String _password;

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(8, 8, 343, 0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF222222),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(14, 34, 213, 73),
              child: Text(
                'Sign up',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 34,
                  height: 1.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomContainer(
                    text: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    onSaved: (value) => _nome = value,
                    onChanged: (value) => _email = value,
                  ),
                  CustomContainer(
                    text: 'Senha',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSaved: (value) => _password = value,
                    onChanged: (value) => _password = value,
                  ),
                  CustomContainer(
                    text: 'Confirme a senha',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    //validator: (value) => value.compareTo(_password);
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/signin'),
              child: Container(
                margin: EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ainda não tem uma conta?',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                        fontSize: 14,
                        height: 1.4285,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(
                        Icons.trending_flat,
                        color: Color(0xFFDB3022),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                _formKey.currentState.save();
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password);
                  // var userName = AdditionalUserInfo();
                  // _nome = userName.username.toString();
                  //Navigator.of(context).pushReplacementNamed('/map');
                } on FirebaseAuthException catch (e) {
                  if (e.code == "weak-password") {
                    print('The password provied is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 28, 16, 126),
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFFDB3022),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 8,
                      color: Color.fromRGBO(211, 38, 38, 0.25),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                      height: 1.4285,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(86, 0, 85, 0),
              child: Text(
                'Or sign up with social account',
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.4285,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(88, 16, 87, 23),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    width: 92,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 8,
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Image.asset('assets/images/iconFacebook.png'),
                  ),
                  Container(
                    width: 92,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 8,
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Image.asset('assets/images/iconGoogle.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
