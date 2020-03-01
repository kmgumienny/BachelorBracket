import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bachelor Bracket"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              _onLocationTap(context, 1);
            },
            child: Text("Sign In"),
          ),
          RaisedButton(
            onPressed: () {
              _onLocationTap(context, 0);
            },
            child: Text("Sign Up"),
          ),
          SignInButton(
            Buttons.Google,
            text: "Sign in with Google",
            onPressed: () {
              signInWithGoogle();
            },
          ),
        ],
      ),
    );
  }

  _onLocationTap(BuildContext context, int locationID) {
    var loc = '';
    if (locationID == 0) {
      loc = '/signup';
    } else {
      loc = '/signin';
    }
    Navigator.pushNamed(context, loc);
  }

  Future<void> signInWithGoogle() async {
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

    var firestore = Firestore.instance;

    final snapShot =
        await Firestore.instance.collection("users").document(user.uid).get();

    if (snapShot == null || snapShot.data == null) {
      // Document with id == docId doesn't exist.
      CollectionReference collRef = Firestore.instance.collection('users');
      var usr = {
        "name": user.displayName,
        "points": [0],
        "total": 0,
        "picks": new List<DocumentReference>()
      };
      await collRef.document(user.uid).setData(usr);
    }

    DocumentSnapshot userDetails =
        await firestore.collection("users").document(user.uid).get();
    QuerySnapshot adminDetails =
        await firestore.collection("admin").getDocuments();

    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false,
        arguments: {
          'user': authResult,
          'user_deets': userDetails,
          'admin': adminDetails
        });
  }
}
