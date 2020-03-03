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
    for (var i = 0; i < userNames.length; i++) {

      // bold the current user and places first
      if (userNames[i] == userDetails.data["name"]) {
        scoreTableRows.add(DataRow(cells: [
        DataCell(Text(userNames[i].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(userScores[i].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
        ]));
      }
      else {
        scoreTableRows.add(DataRow(cells: [
        DataCell(Text(userNames[i].toString())),
        DataCell(Text(userScores[i].toString())),
        ]));
      }

      
    }
    scoreTableRows.sort((a,b)=> b.cells[1].child.toString().compareTo(a.cells[1].child.toString()));

    // create past weeks table rows list
    for (var i = 0; i < userDetails.data["points"].length; i++) {
      pastWeekTableRows.add(DataRow(cells: [
        DataCell(Text("Week " + (i + 1).toString())),
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
                    return SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 100,
                              child: Center(child: Text('Current Leader Board',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)))),
                            DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('User',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Score',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: scoreTableRows,
                              sortColumnIndex: 1,
                              sortAscending: true,
                            ),
                            Container(
                              height: 100,
                              child: Center(child: Text('Your Past Scores',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)))),
                            DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('Week',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Score',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: pastWeekTableRows,
                            )
                          ]),
                    );
                  }
                })));
  }
}
