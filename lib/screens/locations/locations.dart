import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/Location.dart';
import '../../models/Name.dart';
import 'LocationTile.dart';

class Locations extends StatelessWidget {
  const Locations({
    Key key,
    this.user
}) : super(key: key);
  final AuthResult user;
  @override
  Widget build(BuildContext context) {



    final locations = Location.fetchAll();

    return ScopedModelDescendant<NameModel>(
        builder: (BuildContext context, Widget child, NameModel model){
      return Scaffold(
        appBar: AppBar(
          title: Text('Locations'),
        ),
        body: ListView(
          children: locations
              .map((location) =>
              GestureDetector(
                child: LocationTile(location.name, location.imagePath),
                onTap: () => _onLocationTap(context, location.id),
              ))
              .toList(),
        ),
      );
    },
    );
  }


  _onLocationTap(BuildContext context, int locationID) {
    Navigator.pushNamed(context, '/cleaningDetails',
        arguments: {"id": locationID});
  }
}
