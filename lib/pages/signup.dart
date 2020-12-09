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
        backgroundColor: Color(0xFFF9F9F9),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 12, 0, 0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(14, 34, 0, 73),
                  child: Text(
                    'Cadastre-se',
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
                        text: 'Nome',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        onSaved: (value) => _nome = value,
                        onChanged: (value) => _nome = value,
                      ),
                      CustomContainer(
                        text: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        onSaved: (value) => _email = value,
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
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: EdgeInsets.only(right: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Já tem uma conta?',
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
                      var userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password);
                      _nome = userCredential.user.displayName;
                      Navigator.of(context).pushReplacementNamed('/map');
                    } on AuthException catch (e) {
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
                        'CADASTRE-SE',
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
