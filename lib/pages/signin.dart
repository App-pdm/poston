import 'package:flutter/material.dart';
import 'package:poston/models/sign_in.dart';
import 'package:poston/widgets/containertext.dart';
import 'package:poston/widgets/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninPage extends StatelessWidget {
  String _email;
  String _password;

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8, 8, 343, 0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(14, 34, 213, 73),
                  child: Text(
                    'Entrar',
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
                        validator: Validator().emailValidate,
                        onSaved: (value) => _email = value,
                      ),
                      CustomContainer(
                        text: 'Senha',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: Validator().validatePassword,
                        onSaved: (value) => _password = value,
                        onChanged: (value) => _password = value,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/signup'),
                  child: Container(
                    margin: EdgeInsets.only(right: 16, top: 8),
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
                    if (_formKey.currentState.validate()) {
                      try {
                        _formKey.currentState.save();
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        Navigator.of(context).pushReplacementNamed('/start');
                      } on AuthException catch (e) {
                        if (e.code == "weak-password") {
                          print('The password provied is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 28, 16, 0),
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
                        'ENTRAR',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 14,
                          height: 1.4285,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/forgot'),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 16, 16, 110),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDB3022),
                            fontSize: 14,
                            height: 1.4285,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Ou entre com suas redes sociais',
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
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          signInFB().whenComplete(() => Navigator.of(context)
                              .pushReplacementNamed('/start'));
                        },
                        child: Container(
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
                      ),
                      GestureDetector(
                        onTap: () async {
                          signInWithGoogle().whenComplete(() =>
                              Navigator.of(context)
                                  .pushReplacementNamed('/start'));
                        },
                        child: Container(
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
