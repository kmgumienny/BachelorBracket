import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/Name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInScreen();
  }
}

class SignInScreen extends State<SignIn> {
  var _email;
  var _pass;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _getFields() {
    return Column(children: <Widget>[
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

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (!_formKey.currentState.validate()) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Error signing in."),
        content: Text("You must complete all fields."),
      );
      showDialog(context: context, builder: (_) => alertDialog);
      return;
    }
    formState.save();
    try {
      AuthResult user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _pass);
      _onLocationTap(context, user);
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NameModel>(
        builder: (BuildContext context, Widget child, NameModel model) {
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
//                    Image.network('https://media.giphy.com/media/3DnDRfZe2ubQc/giphy.gif'),
                      //TODO Add a picture of the bachelor!
                      SizedBox(height: 100),
                      _getFields(),
                      SizedBox(
                        height: 100,
                      ),
                      RaisedButton(
                          child: Text(
                            'Sign in Now',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            signIn();
                          })
                    ],
                  ),
                ])),
          ));
    });
  }

  _onLocationTap(BuildContext context, AuthResult user) {
    Navigator.pushReplacementNamed(context, '/home', arguments: {'user': user});
  }
}
