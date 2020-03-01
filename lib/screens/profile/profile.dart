import 'package:bachbracket/models/picks.dart';
import 'package:bachbracket/widgets/women.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  final name;
  final uid;
  final points;
  final week;
  final picks;
  Profile(this.name, this.uid, this.points, this.week, this.picks);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text("Your points: " + widget.points.toString()),
            Text("Week number: " + widget.week.toString()),
            // Text("Number of picks this week " + widget.picks.toString()),
            // Text("We need to make this screen look better and add functionality"
            //     " for copmuting score"),
            Expanded(child: WomensList(widget.uid, widget.week)),
          ],
        ),
      ),
    );
  }
}
