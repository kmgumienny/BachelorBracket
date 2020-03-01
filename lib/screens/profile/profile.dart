import 'package:bachbracket/widgets/women.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  final name;
  final uid;
  Profile(this.name, this.uid);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _points;
  int _week;
  Future<Object> getDetails() async {
    var firestore = Firestore.instance;
    DocumentSnapshot userDetails =
        await firestore.collection("users").document(widget.uid).get();
    QuerySnapshot adminQuery =
        await firestore.collection("admin").getDocuments();
    DocumentSnapshot adminDetails = adminQuery.documents[0];

    print(userDetails.data);

    return {
      "week": await adminDetails.data["week"],
      "total": await userDetails.data["total"]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: FutureBuilder(
                future: getDetails(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading"),
                    );
                  } else {
                    return Column(children: <Widget>[
                      Text("Your points: " + snapshot.data["total"].toStringAsFixed(2)),
                      Text("Week number: " + snapshot.data["week"].toString()),
                      Expanded(child: WomensList(widget.uid, snapshot.data["week"])),
                    ]);
                  }
                })));
  }
}
