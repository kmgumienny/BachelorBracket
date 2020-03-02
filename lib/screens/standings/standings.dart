import 'package:bachbracket/widgets/women.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';


class Standings extends StatefulWidget {
  final name; 
  final uid;
  

  Standings(this.name, this.uid);

    @override
    _StandingsState createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  var _points;
  var userNames = [];
  var userScores = [];
  int _week;
  Future<Object> getDetails() async {
    var firestore = Firestore.instance;
    DocumentSnapshot userDetails =
        await firestore.collection("users").document(widget.uid).get();
    QuerySnapshot adminQuery =
        await firestore.collection("admin").getDocuments();
    DocumentSnapshot adminDetails = adminQuery.documents[0];
    
    QuerySnapshot allUserTotals = 
        await firestore.collection("users").getDocuments();

    var i = 0;
    while(allUserTotals.documents.length > i){
      DocumentSnapshot user2Details = allUserTotals.documents[i];
      user2Details.data.forEach((k, v) => {
        userNames.add(k),
        userScores.add(v),
      });

    

      i++;
    }
    

    print(userScores);

    return {
      "numUsers": i,
      "names": userNames,
      "scores": userScores,
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
                      Text("Your points: " + snapshot.data["total"].toStringAsFixed(2)),
                      Text("Week number: " + snapshot.data["userScores"].toString()),
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow( children: [
                            Column(children: [
                              Text('Week Number')
                            ]),
                            Column(children: [
                              Text('Score')
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 1')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][0].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 2')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][1].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 3')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][2].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 4')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][3].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 5')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][4].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 6')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][5].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 7')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][6].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 8')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][7].toStringAsFixed(2))
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text('Week 9')
                            ]),
                            Column(children: [
                              Text(snapshot.data["points"][8].toStringAsFixed(2))
                            ])
                          ]),
                        ]
                      ),
                      Text('Standings'),
                      Table(border: TableBorder.all(),
                        children: [
                          TableRow( children: [
                            Column(children: [
                              Text('UserName')
                            ]),
                            Column(children: [
                              Text('Total Score:')
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text(userScores[1].toString())
                            ]),
                            Column(children: [
                              Text(userScores[0].toString())
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text(userScores[5].toString())
                            ]),
                            Column(children: [
                              Text(userScores[4].toString())
                            ])
                          ]),
                          TableRow( children: [
                            Column(children: [
                              Text(userScores[9].toString())
                            ]),
                            Column(children: [
                              Text(userScores[8].toString())
                            ])
                          ]),
                        ]),
                    ]);
                  }
                })));
  }
}
