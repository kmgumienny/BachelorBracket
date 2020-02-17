import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Picks extends StatefulWidget {
  @override
  _PicksState createState() => _PicksState();
}

class _PicksState extends State<Picks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getWomenList(),
    );
  }

  Future getWomen() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
        await firestore.collection("women").orderBy("week").getDocuments();
    return qn.documents;
  }

  FutureBuilder getWomenList() {
    return FutureBuilder(
      future: getWomen(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading"),
          );
        } else {
          return ListView.builder(
//              itemExtent: 150.0,
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
                            ),
                            ListTile(
                              title: Text("Dummy Title"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  snapshot.data[index].data["name"],
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
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
