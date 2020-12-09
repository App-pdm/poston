import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final fbLogin = FacebookLogin();
String photo;
String nome;
String email;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return null;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

Future<String> signInFB() async {
  var result = await fbLogin.logIn(['email', 'public_profile']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      final authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(user.displayName != null);
      assert(user.photoUrl != null);
      assert(user.email != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      break;
    case FacebookLoginStatus.cancelledByUser:
      print("Facebook login cancelled");
      break;
    case FacebookLoginStatus.error:
      print(result.errorMessage);
      break;
  }
  return null;
}

void signOutFacebook() async {
  await fbLogin.logOut();
}
