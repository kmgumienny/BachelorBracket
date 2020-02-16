import 'package:flutter/material.dart';
import 'imageBanner.dart';
import 'TextSection.dart';
import '../../models/Location.dart';
import '../../models/Name.dart';
import 'package:scoped_model/scoped_model.dart';


class LocationDetail extends StatelessWidget {
  final int _locationID;

  LocationDetail(this._locationID);

  @override
  Widget build(BuildContext context) {
    final location = Location.fetchByID(_locationID);

    return ScopedModelDescendant<NameModel>(
        builder: (BuildContext context, Widget child, NameModel model)
    {
      return Scaffold(
          appBar: AppBar(
            title: Text(location.name),
          ),
          body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ImageBanner(location.imagePath),
                    ]
                      ..addAll(textSections(context, location))),
              )

          )
      );
    }
    );
  }

  List<Widget> textSections(BuildContext context, Location location) {
    return location.cleanings.details
        .map((detail) => GestureDetector(
      child: TextSection(detail.name, detail.description),
      onTap: () => _onLocationTap(context, _locationID, detail.id),
    ))
        .toList();
  }

  _onLocationTap(BuildContext context, int locationID, int cleaningID) {
    Navigator.pushNamed(context, '/detailDescription',
        arguments: {"locationID": locationID, "cleaningID": cleaningID});
  }
}
