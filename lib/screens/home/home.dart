import 'package:bachbracket/screens/picks/picks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachbracket/screens/standings/standings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final AuthResult user;

  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Standings(Colors.white),
    Standings(Colors.green),
    Picks()
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
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

  Future getUser() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
        await firestore.collection("users").where('uid', isEqualTo: widget.user.user.uid).getDocuments();
    return qn.documents;
  }
}
