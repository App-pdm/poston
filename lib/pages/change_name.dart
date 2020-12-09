import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:poston/widgets/containertext.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeNamePage extends StatelessWidget {
  String _nome;
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
                    'Alterar Nome',
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
                      Container(
                        height: 64,
                        margin: EdgeInsets.fromLTRB(15, 0, 17, 8),
                        child: Text(
                          'Por favor, informe o nome que deseja alterar. Depois de enviar, será preciso fazer o login novamente.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF222222),
                            fontFamily: 'Metropolis',
                            height: 1.42,
                          ),
                        ),
                      ),
                      CustomContainer(
                        text: 'Digite seu nome',
                        keyboardType: TextInputType.name,
                        obscureText: false,
                        onSaved: (value) => _nome = value,
                        onChanged: (value) => _nome = value,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    _formKey.currentState.save();
                    var user = await FirebaseAuth.instance.currentUser();
                    var userUpdate = UserUpdateInfo()..displayName = _nome;

                    await user.updateProfile(userUpdate);
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamed('/');
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
                        'ENVIAR',
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
              ],
            ),
          ),
        ));
  }
}
