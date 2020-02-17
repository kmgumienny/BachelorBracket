import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpScreen();
  }
}

class SignUpScreen extends State<SignUp> {
  var _name;
  var _email;
  var _pass;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _getFields() {
    return Column(children: <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Enter Name'),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name is required';
          }
          _name = value;
          return null;
        },
        onSaved: (String value) {
          _name = value;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Enter Email'),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Email is required';
          }
          _email = value;
          return null;
        },
        onSaved: (String value) {
          _email = value;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Enter Password'),
        validator: (String pass) {
          if (pass.isEmpty) {
            return 'Password is required, dummy';
          }
          if (pass.length < 6) {
            return 'Password must be longer than 6 chars';
          }
          _pass = pass;
          return null;
        },
        onSaved: (String value) {
          _pass = value;
        },
        obscureText: true,
      ),
    ]);
  }

  Future<void> signUpFirebase() async {
    final formState = _formKey.currentState;
    if (!_formKey.currentState.validate()) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Error signing up."),
        content: Text("You must complete all fields."),
      );
      showDialog(context: context, builder: (_) => alertDialog);
      return;
    }
    formState.save();
    try {
      AuthResult user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _pass);
      DocumentReference ref = await Firestore.instance
          .collection('users')
          .add({"name": _name, "points": 0, "uid": user.user.uid, "week": 0});
      AlertDialog alertDialog = AlertDialog(
        title: Text("Successfully created account."),
        content: Text("Please Sign In."),
      );
      showDialog(context: context, builder: (_) => alertDialog);

      _onLocationTap(context);
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Login Here'),
          ),
          body: Container(
            margin: EdgeInsets.all(24),
            child: Form(
                key: _formKey,
                child: ListView(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 100),
                      _getFields(),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            signUpFirebase();
                          })
                    ],
                  ),
                ])),
          ));
  }

  _onLocationTap(BuildContext context) {
    Navigator.pushReplacementNamed(
      context, '/signin',
    );
  }
}
