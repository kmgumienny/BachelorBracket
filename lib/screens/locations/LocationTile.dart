import 'package:flutter/material.dart';
import '../../style.dart';

class LocationTile extends StatelessWidget {
  final String _title;
  final String _imagePath;

  LocationTile(this._title, this._imagePath);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: (MediaQuery.of(context).size.height - kToolbarHeight) / 2 - 12,
        decoration: new BoxDecoration(
//            borderRadius: new BorderRadius.only(
//                topLeft: const Radius.circular(40.0),
//                topRight: const Radius.circular(40.0),
//                bottomRight: const Radius.circular(40.0),
//                bottomLeft: const Radius.circular(40.0)),
            image: DecorationImage(
              image: new AssetImage(_imagePath),
              fit: BoxFit.fill,
            )),
//            child: Image.asset(
//              _imagePath,
//              fit: BoxFit.cover,
//            )
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 50.0,
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red, Colors.white])),
          alignment: Alignment.center,
          child: Text(
            _title,
            style: TextStyle(
              fontFamily: fontNameDefault,
              fontWeight: FontWeight.w500,
              fontSize: LargeTextSize,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
