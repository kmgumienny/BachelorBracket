import 'package:flutter/material.dart';
import '../locationDetail/imageBanner.dart';
import 'TextSection.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/Name.dart';
import '../../models/LocationCleaning.dart';
import 'package:intl/intl.dart';
import '../../models/Cleaner.dart';
import 'package:sqflite/sqflite.dart';
import '../../utils/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailDescription extends StatefulWidget{
  final int _location_ID;
  final int _cleaningID;
  const DetailDescription(this._location_ID, this._cleaningID);
  @override
  State<StatefulWidget> createState(){
    return Description();
  }
}


class Description extends State<DetailDescription> {
  List<Cleaner> cleanerList;
  var count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  String uid;

  @override
  Widget build(BuildContext context) {
    final cleaning = LocationCleaning.getCleaning(widget._location_ID, widget._cleaningID);

    if (cleanerList == null) {
      cleanerList = List<Cleaner>();
      updateCleanerList();
    }

    return ScopedModelDescendant<NameModel>(
        builder: (BuildContext context, Widget child, NameModel model) {
          return Scaffold(
              appBar: AppBar(
                title: Text(cleaning.name),
              ),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ImageBanner(cleaning.imagePath),
                    TextSection(cleaning.name, cleaning.description),
                    Container(
                        margin: EdgeInsets.all(10.0),
                        child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                uid = '${model.name}';
                                saveCleaning(uid);
                              }
                              );
                            },
                            child: Text('Complete?'))),
                          new Expanded(
                            child: getCleaningListView(),),
                    
                  ]
              )
          );
        }
        );
    }

  void updateCleanerList(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Cleaner>> cleanerListFuture = databaseHelper.getCleanerList();
      cleanerListFuture.then((cleanerList) {
        setState(() {
          this.cleanerList = cleanerList;
          this.count = cleanerList.length;
        });
      });
    });
  }

  Future<String> firebaseGetUser(String uid) async {
    String name = "null";
    await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        print(ds.data['name'].toString());
        name = ds.data['name'].toString();
      }
      else {
        print("No such user");
      }
    });
    return name;
  }

  ListView getCleaningListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              title: Text(this.cleanerList[position].cleaningComp, style: titleStyle,),
          ),
        );
      },
    );
  }

// Poor mans way of clearing the database.
//  void saveCleaning(String uid) async {
//    for (int i = 0; i < count; i++){
//      databaseHelper.deleteCleaning(cleanerList[i].id);
//    }
//  }
  void saveCleaning(String uid) async {
    //    String username = await firebaseGetUser(uid);
    await firebaseGetUser(uid).then((username) => {
      saveToDatabase(username),});
  }

  void saveToDatabase(String username) async {
    int result;
    var now = DateFormat.yMMMd("en_US").format(DateTime.now());
    String cleaning = "Completed on " + now + " by " + username;
    Cleaner newCleaning = Cleaner(username, cleaning);
    result = await databaseHelper.insertCleaning(newCleaning);

    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Cleaning saved."),
        content: Text("Succesfully added cleaning to sqllite"),
      );
      showDialog(
          context: context,
          builder: (_) => alertDialog
      );
    }
    else if (result == 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Cleaning not saved."),
        content: Text("There was an error saving the cleaning."),
      );
      showDialog(
          context: context,
          builder: (_) => alertDialog
      );
    }
    updateCleanerList();
  }

}
