import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<FirebaseUser> getUser() async {
  var user = await FirebaseAuth.instance.currentUser();
  return user;
}

class ProfilePage extends StatelessWidget {
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
                onTap: () =>
                    Navigator.of(context).pushNamed('/profile/changename'),
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 8, 0),
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
                        margin: EdgeInsets.only(),
                        padding: EdgeInsets.only(right: 8, top: 24, bottom: 24),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF9B9B9B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.black),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.fromLTRB(15, 0, 8, 0),
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
                        margin: EdgeInsets.only(left: 180),
                        padding: EdgeInsets.only(right: 8, top: 24, bottom: 24),
                        child: Icon(
                          Icons.logout,
                          color: Color(0xFF9B9B9B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Color.fromRGBO(155, 155, 155, 0.05)),
            ],
          ),
        ),
      ),
    );
  }
}
