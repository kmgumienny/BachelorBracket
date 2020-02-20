import 'package:cloud_firestore/cloud_firestore.dart';

class UserPicks{
  String _name;
  List<bool> _picks;
  int _points;
  String _uid;
  int _week;


  UserPicks(String name, int points, String uid, int week){
    this._name = name;
    this._picks = List<bool>.filled(30, false);
    this._points = points;
    this._uid = uid;
    this._week = week;
  }

  UserPicks.fromDatabase(String name, List<bool> picks, int points, String uid, int week){
    this._name = name;
    this._picks = List<bool>.filled(30, false);
    this._points = points;
    this._uid = uid;
    this._week = week;
  }

  String get name => _name;
  List<bool> get picks => _picks;
  int get points => _points;
  String get uid => _uid;
  int get cleaningComp => _week;


  set name(String newName) {
    this._name = newName;
  }

  void setPicks(Set picks){
    this._picks.fillRange(0, this._picks.length, false);
    for (int i in picks){
      this._picks[i] = true;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['name'] = _name;
    map['picks'] = _picks;
    map['points'] = _points;
    map['uid'] = _uid;
    map['week'] = _week;
    return map;
  }

  // Extract a Pick object from a Map object
  UserPicks.fromSnapshot(DocumentSnapshot ss) {
    this._name = ss.data['name'];
    this._picks = List.castFrom<dynamic, bool>(ss.data['picks']);
    this._points = ss.data['points'];
    this._uid = ss.data['uid'];
    this._week = ss.data['week'];
  }
}