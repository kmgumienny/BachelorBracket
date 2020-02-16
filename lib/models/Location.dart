import 'LocationCleaning.dart';

class Location {
  final int id;
  String name;
  String imagePath;
  LocationCleaning cleanings;

  Location(this.id, this.name, this.imagePath, this.cleanings);

  static List<Location> fetchAll() {
    return [
      Location(1, 'Kitchen', 'assets/images/dining_room.jpg', LocationCleaning(1)),
      Location(2, 'House', 'assets/images/house.jpg', LocationCleaning(2)),
    ];
  }

  static Location fetchByID(int locationID) {
    List<Location> locations = Location.fetchAll();
    for (var i = 0; i < locations.length; i++) {
      if (locations[i].id == locationID) {
        return locations[i];
      }
    }
    return null;
  }
}
