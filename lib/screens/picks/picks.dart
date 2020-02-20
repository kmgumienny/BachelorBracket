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
  var points;
  var numPicked = 0;
  UserPicks weekPicks;
  var pickSet= new Set();
  String documentID;

  Picks(numPicks, uid, weekNum, name, points){
    this.numPicks = numPicks;
    this.uid = uid;
    this.weekNum = weekNum;
    this.name = name;
    this.points = points;
    getUserPicks();
  }



Future getUserPicks() async {
  var firestore = Firestore.instance;
  QuerySnapshot qn = await firestore.collection("picks").where('uid', isEqualTo: uid).where('week', isEqualTo: weekNum).getDocuments();
  if (qn.documents.length != 0){
    weekPicks = UserPicks.fromSnapshot(qn.documents[0]);
    documentID = qn.documents[0].documentID;
    for (int i = 0; i < 30; i++){
      if (weekPicks.picks[i] == true) {
        pickSet.add(i);
        numPicked++;
      }
    }
  } else {
    weekPicks = UserPicks(name, points, uid, weekNum);
  }
}
}


//Future getUserPicks() async {
//  var firestore = Firestore.instance;
//  QuerySnapshot qn = await firestore.collection("picks").where('uid', isEqualTo: uid).where('week', isEqualTo: weekNum).getDocuments();
//  if (qn.documents.length != 0){
//    weekPicks = UserPicks.fromSnapshot(qn.documents[0]);
//    documentID = qn.documents[0].documentID;
//    for (int i = 0; i < 30; i++){
//      if (weekPicks.picks[i] == true) {
//        pickSet.add(i);
//        numPicked++;
//      }
//    }
//  } else {
//    weekPicks = UserPicks(name, points, uid, weekNum);
//  }
//}

class _PicksState extends State<Picks> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: getWomenList(),
        floatingActionButton: getFloatyButton(),
    );
  }

  Future getWomen() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
        await firestore.collection("women").orderBy("week", descending: true).getDocuments();
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
          return
            ListView.builder(
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
                              isStillIn(snapshot.data[index].data["week"], snapshot.data[index].data["id"]),


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

  Widget isStillIn(weekNum, ladyID){
    if(weekNum != 100) {
      return
        ListTile(
          title: Center(child: Text("Eliminated Week " + weekNum.toString()),),
        );
    }else {
      if (widget.numPicks != widget.weekPicks && widget.pickSet.contains(ladyID)){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Center(child: Text("Change your mind?"),),
                onPressed: () => onPress(ladyID),
              color: Colors.red,
            )
          ],
        );
      } else if (widget.numPicks != widget.weekPicks && !widget.pickSet.contains(ladyID)) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Center(child: Text("Pick me?"),),
                  onPressed: () => onPress(ladyID),
                color: Colors.green,
              )
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Center(child: Text("Unavailable"),),
                  onPressed: () => null
              ),
            ],
          );
        }


    }
  }

  Widget getFloatyButton() {
    if (widget.numPicked != widget.numPicks) {
      return FloatingActionButton.extended(
        onPressed: () {
          return null;
        },
        label: Text('Picked ' + widget.numPicked.toString() + " of " +
            widget.numPicks.toString() + " this week"),
        icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          saveUserPicks();
        },
        label: Text("Save these " + widget.numPicked.toString() + " picks?"),
        icon: Icon(Icons.save),
        backgroundColor: Colors.pink,
      );
    }
  }

  void onPress(int id) {
    print('pressed $id');
    if (widget.numPicked == widget.numPicks && !widget.pickSet.contains(id)){
      AlertDialog alertDialog = AlertDialog(
        title: Center(child: Text("Error Adding"),),
        content: Text("Unselect someone before re-choosing."),
      );
      showDialog(context: context, builder: (_) => alertDialog);
      return;
    }else {
      if (widget.pickSet.contains(id)) {
        widget.pickSet.remove(id);
        setState(() {
          widget.numPicked--;
        });
      } else{
        setState(() {
          widget.pickSet.add(id);
          widget.numPicked++;
        });
      }
    }
  }

  Future saveUserPicks() async {
    var firestore = Firestore.instance;
    widget.weekPicks.setPicks(widget.pickSet);
    Map saveSet = widget.weekPicks.toMap();

    firestore.runTransaction((Transaction transactionHandler) {
      if (widget.documentID != null) {
        return firestore.collection('picks').document(widget.documentID).updateData(saveSet);
      } else
      return firestore.collection('picks').document().setData(saveSet);
    });

    AlertDialog alertDialog = AlertDialog(
      title: Center(child: Text("Succesfully saved picks!"),),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
