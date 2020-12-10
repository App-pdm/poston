import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:poston/widgets/containertext.dart';

Future<FirebaseUser> getUser() async {
  var user = await FirebaseAuth.instance.currentUser();
  return user;
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _onTappedPassword() {
      String _oldpassword;
      String _password;
      var _formKey = GlobalKey<FormState>();
      String _key;

      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 36),
            height: 375,
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -4),
                  color: Color.fromRGBO(249, 249, 249, 0.08),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(top: 36)),
                  Center(
                    child: Text(
                      'Mudar Senha',
                      style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 18,
                          height: 0.8,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 18)),
                  CustomContainer(
                    text: 'Nova Senha',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSaved: (value) => _password = value,
                    onChanged: (value) => _password = value,
                  ),
                  CustomContainer(
                    text: 'Confirme a Senha',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 14, right: 14),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/forgot'),
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 14,
                          height: 0.7,
                          color: Color(0xFF9B9B9B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _formKey.currentState.save();
                      var user = await FirebaseAuth.instance.currentUser();
                      user.updatePassword(_password);
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamed('/');
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 32, 16, 0),
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
                          'SALVAR',
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
                ],
              ),
            ),
          );
        },
      );
    }

    void _onTappedName() {
      String _nome;
      var _formKey = GlobalKey<FormState>();

      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 36),
            height: 375,
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -4),
                  color: Color.fromRGBO(249, 249, 249, 0.08),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(padding: EdgeInsets.only(top: 36)),
                  Center(
                    child: Text(
                      'Mudar Nome',
                      style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 18,
                          height: 0.8,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 18)),
                  CustomContainer(
                    text: 'Digite o nome e clique em salvar.',
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    onSaved: (value) => _nome = value,
                    onChanged: (value) => _nome = value,
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
                      margin: EdgeInsets.fromLTRB(16, 32, 16, 0),
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
                          'SALVAR',
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
                ],
              ),
            ),
          );
        },
      );
    }

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
                margin: EdgeInsets.fromLTRB(14, 34, 0, 0),
                child: Text(
                  'Meu Perfil',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 34,
                    height: 1.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getUser(),
                    builder: (_, snapshot) =>
                        snapshot.hasData && snapshot.data.photoUrl != null
                            ? Container(
                                margin: EdgeInsets.fromLTRB(17, 24, 19, 28),
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(snapshot.data.photoUrl),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.fromLTRB(17, 24, 19, 28),
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/user.jpg'),
                                  ),
                                ),
                              ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: getUser(),
                          builder: (_, snapshot) => snapshot.hasData &&
                                  snapshot.data.displayName != null
                              ? Text(
                                  snapshot.data.displayName,
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 18,
                                    height: 1.222,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222),
                                  ),
                                )
                              : Text(
                                  '',
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                    fontSize: 18,
                                    height: 1.222,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                        ),
                        FutureBuilder(
                          future: getUser(),
                          builder: (_, snapshot) =>
                              snapshot.hasData && snapshot.data.email != null
                                  ? Text(
                                      snapshot.data.email,
                                      style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        fontSize: 14,
                                        height: 1.428,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF9B9B9B),
                                      ),
                                    )
                                  : Text(
                                      '',
                                      style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        fontSize: 18,
                                        height: 1.222,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF222222),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () async => _onTappedName(),
                child: Container(
                  width: double.infinity,
                  height: 72,
                  padding: EdgeInsets.fromLTRB(15, 18, 8, 0),
                  // decoration: BoxDecoration(
                  //   border: Border.all(),
                  // ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alterar Nome',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 18,
                              height: 1.222,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),
                          Text(
                            'Clique para alterar o seu nome',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 14,
                              height: 1.428,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9B9B9B),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 152),
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF9B9B9B),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Color.fromRGBO(000, 000, 000, 0.1),
                height: 1,
              ),
              GestureDetector(
                onTap: () async => _onTappedPassword(),
                child: Container(
                  width: double.infinity,
                  height: 72,
                  padding: EdgeInsets.fromLTRB(15, 18, 8, 0),
                  // decoration: BoxDecoration(
                  //   border: Border.all(),
                  // ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alterar Senha',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 18,
                              height: 1.222,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),
                          Text(
                            'Clique para alterar a senha',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 14,
                              height: 1.428,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9B9B9B),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 177),
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF9B9B9B),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Color.fromRGBO(000, 000, 000, 0.1),
                height: 1,
              ),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Container(
                  width: double.infinity,
                  height: 72,
                  padding: EdgeInsets.fromLTRB(15, 18, 8, 0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 18,
                              height: 1.222,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),
                          Text(
                            'Clique para fazer o logout',
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 14,
                              height: 1.428,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9B9B9B),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 184),
                        child: Column(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Color(0xFF9B9B9B),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Color.fromRGBO(000, 000, 000, 0.1),
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
