import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                margin: EdgeInsets.fromLTRB(14, 34, 213, 0),
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
                    builder: (_, snapshot) => snapshot.hasData
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
                            ),
                            child: CircularProgressIndicator(
                              backgroundColor: Color(0xFFE5E5E5),
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
                          builder: (_, snapshot) => snapshot.hasData
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
                              : Container(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Color(0xFFE5E5E5),
                                  ),
                                ),
                        ),
                        FutureBuilder(
                          future: getUser(),
                          builder: (_, snapshot) => snapshot.hasData
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
                              : Container(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Color(0xFFE5E5E5),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
