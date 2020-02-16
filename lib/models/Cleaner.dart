class Cleaner{
  int _id;
  String _name;
  String _cleaningCompletion;



  Cleaner(this._name, this._cleaningCompletion);

  Cleaner.withId(this._id, this._name, this._cleaningCompletion);

  int get id => _id;
  String get name => _name;
  String get cleaningComp => _cleaningCompletion;


  set name(String newName) {
      this._name = newName;
  }

  set cleaningCompletion(String cleaningComp){
    this._cleaningCompletion = cleaningComp;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['cleaningCompletion'] = _cleaningCompletion;

    return map;
  }

  // Extract a Note object from a Map object
  Cleaner.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._cleaningCompletion = map['cleaningCompletion'];
  }

}