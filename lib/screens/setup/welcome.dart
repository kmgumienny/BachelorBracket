import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          RaisedButton(
            onPressed: () {
              signInWithGoogle();
            },
            child: Text("Sign in with Google"),
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

    final snapShot = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();

    if (snapShot == null || snapShot.documents.length == 0) {
      // Document with id == docId doesn't exist.
      DocumentReference ref = await Firestore.instance.collection('users').add(
          {"name": user.displayName, "points": 0, "uid": user.uid, "week": 0});
    }

    QuerySnapshot userDetails = await firestore
        .collection("users")
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
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
