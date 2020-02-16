import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        ],
      ),
    );
  }


  _onLocationTap(BuildContext context, int locationID) {
    var loc = '';
    if (locationID == 0){
      loc = '/signup';
    } else {
      loc = '/signin';
    }
    Navigator.pushNamed(context, loc);
  }
}
