import 'package:scoped_model/scoped_model.dart';

class NameModel extends Model {
  String _name;

  String get name {
    return _name;
  }

  void updateName(String name) {
    _name = name;
//    notifyListeners();
  }

}