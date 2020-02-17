import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  final name;
  final points;
  final week;

  Profile(this.name, this.points, this.week);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hi"),
    );
  }
}
