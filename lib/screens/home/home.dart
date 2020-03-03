import 'package:bachbracket/screens/picks/picks.dart';
import 'package:bachbracket/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachbracket/screens/standings/standings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final AuthResult user;
  final DocumentSnapshot userDetails;
  final QuerySnapshot adminDetails;

  Home(this.user, this.userDetails, this.adminDetails);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  static QuerySnapshot userData;
  static QuerySnapshot adminData;

  static String name;
  static var points;
  static var week;
  static var picks;
  static var uid;


  @override
  Widget build(BuildContext context) {
    name = widget.userDetails.data["name"];
    points = widget.userDetails.data["points"];
    week = widget.adminDetails.documents[0].data["week"];
    picks = widget.adminDetails.documents[0].data["numpicks"];
    uid = widget.userDetails.documentID;
    List<Widget> _children = [
      Profile(name, uid),
      Standings(name, uid),
      Picks(picks, uid, week, name)
    ];
    return FutureBuilder(
        future: getSetup(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              //child: Text("Loading"),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                  title: new Center(
                child: Text('Welcome ' + snapshot.data["name"]),
              )),
              body: _children[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.pink,
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.mood),
                    title: new Text('Me'),
                   
                  ),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.assessment),
                    title: new Text('Standings'),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.face), 
                      title: Text('Picks'))
                ],
              ),
            );
          }
        });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future getSetup() async {
    var firestore = Firestore.instance;
    DocumentSnapshot dn =
        await firestore.collection("users").document(uid).get();
    return dn;
  }
}
