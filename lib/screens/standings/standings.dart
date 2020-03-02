import 'package:bachbracket/widgets/women.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Standings extends StatefulWidget {
  final name;
  final uid;

  Standings(this.name, this.uid);

  @override
  _StandingsState createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  var userNames = [];
  var userScores = [];
  var scoreTableRows = new List<DataRow>();
  var pastWeekTableRows = new List<DataRow>();

  Future<Object> getDetails() async {
    var firestore = Firestore.instance;
    
    // current user
    DocumentSnapshot userDetails =
        await firestore.collection("users").document(widget.uid).get();
    
    // admin
    QuerySnapshot adminQuery =
        await firestore.collection("admin").getDocuments();
    DocumentSnapshot adminDetails = adminQuery.documents[0];

    // get all users
    QuerySnapshot allUsersQuery =
        await firestore.collection("users").getDocuments();
    
    // populate array with all users
    for (var user in allUsersQuery.documents) {
        userScores.add(user.data["total"]);
        userNames.add(user.data["name"]);
    }

    // create all scores table rows list
    for (var i=0; i<userNames.length; i++) {
      scoreTableRows.add(DataRow(cells: [
        DataCell(Text(userNames[i].toString())),
        DataCell(Text(userScores[i].toString())),
      ]));
    }

    // create past weeks table rows list
    for (var i=0; i<userDetails.data["points"].length ; i++) {
      print(userDetails.data["points"].length);
      pastWeekTableRows.add(DataRow(cells: [
        DataCell(Text("Week " + (i+1).toString())),
        DataCell(Text(userDetails.data["points"][i].toString())),
      ]));
    }

    return {
      "numUsers": userNames.length,
      "names": userNames,
      "scores": userScores,
      "scoreTableRows": scoreTableRows,
      "pasWeekTableRows": pastWeekTableRows,
      "week": await adminDetails.data["week"],
      "total": await userDetails.data["total"],
      "points": await userDetails.data["points"]
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
                      Text("Your points: " +
                          snapshot.data["total"].toStringAsFixed(2)),
                      Text("Week number: " + snapshot.data["week"].toString()),
                      DataTable(
                        columns: [
                          DataColumn(label: Text('User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                        ],
                        rows: scoreTableRows,
                      ),
                      DataTable(
                        columns: [
                          DataColumn(label: Text('Week', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                        ],
                        rows: pastWeekTableRows,
                      )
                    ]);
                  }
                }))
    );
  }


}
