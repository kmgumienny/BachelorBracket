import 'package:bachbracket/models/picks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WomensList extends StatelessWidget {
  // WomensList({this.picks});
  UserPicks picks;
  var pickSet = new Set();

  WomensList(this.uid, this.week);
  final uid;
  final week;

  Future getWomen() async {
    var firestore = Firestore.instance;
    var picks = new List<DocumentSnapshot>();
    DocumentSnapshot userDetails =
        await firestore.collection("users").document(uid).get();

    // for (int i = 0; i < 30; i++) {
    //   if (picks.picks[i] == true) {
    //     pickSet.add(i);
    //   }
    // }
    print(userDetails.data);
    for (var pick in userDetails.data["picks"]) {
      picks.add(await pick.get());
    }
    return picks;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWomen(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading..."),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return Card(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 150.0,
                        width: 150.0,
                        child: Image.asset(
                          snapshot.data[index].data["pic"],
                          height: 300,
                          width: 150,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ListTile(
                              title: new Center(
                                  child: new Text(
                                snapshot.data[index].data["name"],
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25.0),
                              )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        }
      },
    );
  }
}
