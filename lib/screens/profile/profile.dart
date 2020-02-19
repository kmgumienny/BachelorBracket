import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  final name;
  final points;
  final week;
  final picks;

  Profile(this.name, this.points, this.week, this.picks);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(widget.name),
          Text("Your points " + widget.points.toString()),
          Text("Week number: " + widget.week.toString()),
          Text("Number of picks this week " + widget.picks.toString()),
        ],
      ),
    );
  }
}
