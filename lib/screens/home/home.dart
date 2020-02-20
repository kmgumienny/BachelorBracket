import 'package:bachbracket/screens/picks/picks.dart';
import 'package:bachbracket/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachbracket/screens/standings/standings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final AuthResult user;
  final QuerySnapshot userDetails;
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
    name = widget.userDetails.documents[0].data["name"];
    points = widget.userDetails.documents[0].data["points"];
    week = widget.adminDetails.documents[0].data["week"];
    picks = widget.adminDetails.documents[0].data["numpicks"];
    uid = widget.userDetails.documents[0].data["uid"];
    List<Widget> _children = [
//    Profile(userData.documents[0].data[0].data["name"], userData.documents[0].data[0].data["points"], adminData.documents[0].data[0].data["week"], adminData.documents[0].data[0].data["numpicks"]),
      Profile(name, points, week, picks),
      Standings(Colors.green),
      Picks(picks, uid, week, name, points)
    ];
    return FutureBuilder(
        future: getSetup(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading"),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                  title: new Center(
                child: Text('Welcome ' + snapshot.data[0].data["name"]),
              )),
              body: _children[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
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
                      icon: Icon(Icons.face), title: Text('Picks'))
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
    QuerySnapshot qn =
        await firestore.collection("users").where('uid', isEqualTo: widget.user.user.uid).getDocuments();
    return qn.documents;
  }
}
