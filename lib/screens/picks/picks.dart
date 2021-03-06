import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bachbracket/models/picks.dart';
import 'package:async/async.dart';

class Picks extends StatefulWidget {
  @override
  _PicksState createState() => _PicksState();
  var numPicks;
  var uid;
  var weekNum;
  var name;
  Picks(numPicks, uid, weekNum, name) {
    this.numPicks = numPicks;
    this.uid = uid;
    this.weekNum = weekNum;
    this.name = name;
  }
}

class _PicksState extends State<Picks> {
  var _numPicked = 0;
  var _picks = new List<DocumentSnapshot>();
  var _picksID = new List<String>();
  String _documentID;
  var _total;
  var _points;

  @override
  void initState() {
    super.initState();
    getUserPicks();
  }
  @override
  Widget build(BuildContext context) {
    print("Points: $_points");
    return getWomenList();
  }

  Future getUserPicks() async {
    var firestore = Firestore.instance;
    DocumentSnapshot userDetails =
        await firestore.collection("users").document(widget.uid).get();

    print(userDetails.data);
    var total = userDetails.data["total"];
    var points = userDetails.data["points"];
    var picks = new List<DocumentSnapshot>();
    var picksID = new List<String>();
    for (var pick in userDetails.data["picks"]) {
      picks.add(await pick.get());
      picksID.add(pick.documentID);
    }
    setState(() {
      _total = total;
      _picks = picks;
      _points = points;
      _picksID = picksID;
      _numPicked = picks.length;
    });
  }

  Future getWomen() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("women")
        .orderBy("week", descending: true)
        .getDocuments();
    return qn.documents;
  }

  FutureBuilder getWomenList() {
    return FutureBuilder(
      future: getWomen(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:
              Column(
                children: <Widget>[
                  Container(height: MediaQuery.of(context).size.height/3),
                  Text("Loading...",
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                    )),
                  Image.asset(
                    "./assets/images/rose.png",
                    height: 150,
                    width: 150,
                  ),
                ]),
          );
        } else {
          return Scaffold(
              body: ListView.builder(
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
                            child: Opacity(
                                opacity: snapshot.data[index].data["week"] == 100? 1 : 0.3, 
                                  child: Image.asset(
                                  snapshot.data[index].data["pic"],
                                  height: 300,
                                  width: 150,
                                )),
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
                                isStillIn(snapshot.data[index]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              floatingActionButton: getFloatyButton());
        }
      },
    );
  }

  Widget isStillIn(contestant) {
    print(
        "How many have been picked?:  $_numPicked/${widget.numPicks}");
    print(contestant.documentID);
    if (contestant.data["week"] < 100) {
      return ListTile(
        title: Center(
          child: Text("Eliminated Week " + contestant.data["week"].toString()),
        ),
      );
    } else {
      if (_picksID.contains(contestant.documentID)) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Center(
                child: Text("Change your mind?"),
              ),
              onPressed: () => onPress(contestant),
              color: Colors.red,
            )
          ],
        );
      } else if (widget.numPicks != _numPicked &&
          !_picksID.contains(contestant.documentID)) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Center(
                child: Text("Pick me?"),
              ),
              onPressed: () => onPress(contestant),
              color: Colors.green,
            )
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Center(
                  child: Text("Unavailable"),
                ),
                onPressed: () => null),
          ],
        );
      }
    }
  }

  Widget getFloatyButton() {
    if (_numPicked != widget.numPicks) {
      return FloatingActionButton.extended(
        onPressed: () {
          return null;
        },
        label: Text('Picked ' +
            _numPicked.toString() +
            " of " +
            widget.numPicks.toString() +
            " this week"),
        icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          saveUserPicks();
        },
        label: Text("Save these " + _numPicked.toString() + " picks?"),
        icon: Icon(Icons.save),
        backgroundColor: Colors.pink,
      );
    }
  }

  void onPress(dynamic contestant) {
    String name = contestant.data["name"];
    print('pressed $name');
    if (_numPicked == widget.numPicks &&
        !_picksID.contains(contestant.documentID)) {
      AlertDialog alertDialog = AlertDialog(
        title: Center(
          child: Text("Error Adding"),
        ),
        content: Text("Unselect someone before re-choosing."),
      );
      showDialog(context: context, builder: (_) => alertDialog);
      return;
    } else {
      if (_picksID.contains(contestant.documentID)) {
        setState(() {
          _picks.removeWhere((element) => element.documentID == contestant.documentID);
          _picksID.remove(contestant.documentID);
          _numPicked--;
        });
      } else {
        setState(() {
          _picks.add(contestant);
          _picksID.add(contestant.documentID);
          _numPicked++;
        });
      }
    }
  }

  Future saveUserPicks() async {
    var firestore = Firestore.instance;
    List<DocumentReference> picksL = new List<DocumentReference>();
    _picks.forEach((element) {
      picksL.add(element.reference);
    });

    var data = {
      "name": widget.name,
      "points": _points,
      "total": _total,
      "picks": picksL
    };
    firestore.runTransaction((Transaction transactionHandler) {
      if (_documentID != null) {
        return firestore.collection('users').document(widget.uid).setData(data);
      } else
        return firestore.collection('users').document(widget.uid).setData(data);
    });

    AlertDialog alertDialog = AlertDialog(
      title: Center(
        child: Text("Succesfully saved picks!"),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
