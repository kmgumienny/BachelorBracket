import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bachbracket/models/picks.dart';

class Picks extends StatefulWidget {
  @override
  _PicksState createState() => _PicksState();
  final numPicks;
  final uid;
  final weekNum;
  final name;
  final points;
  var numPicked = 0;
  UserPicks weekPicks;
  var pickSet= new Set();

  Picks(this.numPicks, this.uid, this.weekNum, this.name, this.points);
}

class _PicksState extends State<Picks> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      getUserPicks();
      widget.numPicked = widget.pickSet.length;
    });
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
                child: Center(child: Text("Pick me?"),),
                onPressed: () => onPress(ladyID),
              color: Colors.red,
            )
          ],
        );
      } else {
        if (!widget.pickSet.contains(ladyID)) {
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
                  child: Center(child: Text("Pick me?"),),
                  onPressed: () => null
              ),
            ],
          );
        }
      }

    }
  }

  Widget getFloatyButton() {
    if (widget.numPicked != widget.weekPicks) {
      return FloatingActionButton.extended(
        onPressed: () {
          saveUserPicks();
        },
        label: Text('Picked ' + widget.numPicked.toString() + " of " +
            widget.numPicks.toString() + " this week"),
        icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text("Save these " + widget.numPicked.toString() + " picks?"),
        icon: Icon(Icons.save),
        backgroundColor: Colors.pink,
      );
    }
  }

  void onPress(int id) {
    print('pressed $id');
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

  Future getUserPicks() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("picks").where('uid', isEqualTo: widget.uid).where('week', isEqualTo: widget.weekNum).getDocuments();
    if (qn.documents.length != 0){
      widget.weekPicks = UserPicks.fromSnapshot(qn.documents[0]);
      for (int i = 0; i < 30; i++){
        if (widget.weekPicks.picks[i] == true) {
          widget.pickSet.add(i);
          widget.numPicked++;
        }
      }
    } else {
      widget.weekPicks = UserPicks(widget.name, widget.points, widget.uid, widget.weekNum);
    }

  }

  Future saveUserPicks() async {
    var firestore = Firestore.instance;
    widget.weekPicks.setPicks(widget.pickSet);

    Map saveSet = widget.weekPicks.toMap();

    firestore.runTransaction((Transaction transactionHandler) {
      return firestore.collection('picks').document().setData(saveSet);
    });
  }
}
