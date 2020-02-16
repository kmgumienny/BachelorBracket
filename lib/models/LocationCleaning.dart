import 'DetailDescription.dart';

class LocationCleaning {
  int id;
  List<DetailDescription> details;

  LocationCleaning(int id){
    if (id == 1)
      this.details = getKitchen();
    else
      this.details = getHouse();
  }

  static List<DetailDescription> getKitchen(){
    return [
      DetailDescription(-1, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-2, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-3, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-4, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-5, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-6, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-7, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-8, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-9, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-10, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-11, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-12, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-13, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-14, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
      DetailDescription(-15, 'Stairways', 'Sweep and mop the stairways','assets/images/staircase.jpg'),
    ];
  }

  static List<DetailDescription> getHouse(){
    return [
      DetailDescription(1, 'Recycling', 'You clean the surfaces a lot a lot', 'assets/images/clorox.jpg'),
      DetailDescription(2, 'Floors', 'Sweep and mop the basment floors. sweep behind the bar area ', 'assets/images/clorox.jpg'),
      DetailDescription(3, 'Showers', 'Scrub the shower floors. Clean the drains', 'assets/images/clorox.jpg'),
      DetailDescription(4, 'Trash', 'You clean the surfaces a lot a lot', 'assets/images/clorox.jpg'),
      DetailDescription(5, 'Surfaces 1', 'Wipe down the surfaces in the dining room, the HD, alumni room, pool table, ping pong table, and tables next to pool table', 'assets/images/clorox.jpg'),
      DetailDescription(6, 'Surfaces 2', 'Wipe down the table in GComms, the bar, and the piano', 'assets/images/clorox.jpg'),
      DetailDescription(7, 'Surfaces 3', 'Wipe down the warmdorm bar, the counter, pong tables, couch area, and library', 'assets/images/clorox.jpg'),
      DetailDescription(8, 'Hallway', 'Sweep and mop the hallway.', 'assets/images/clorox.jpg'),
      DetailDescription(9, 'Bathroom A', 'wipe and use toilet brush on all the toilets and make sure they are unclogged. Replace urinal cakes', 'assets/images/clorox.jpg'),
      DetailDescription(10, 'Bathroom B', 'Restock all bathroom supplies and clean the mirrors and sinks, dont forget the faucet. Also take down dirty dishwear that was left in the bathroom', 'assets/images/clorox.jpg'),
      DetailDescription(11, 'DJ Booth and Bar', 'You clean the surfaces a lot a lot', 'assets/images/clorox.jpg'),
      DetailDescription(12, 'Laundry Room', 'You clean the surfaces a lot a lot', 'assets/images/clorox.jpg'),
      DetailDescription(13, 'Stairs', 'Sweep and mop the stairs between the 1st and 2nd floor, and also the second floor landing', 'assets/images/clorox.jpg'),
    ];
  }

  static DetailDescription getCleaning(int locationID, int id) {
    List<DetailDescription> details;
    if (locationID == 1)
      details = getKitchen();
    else
      details = getHouse();

    for (var i = 0; i < details.length; i++){
      if (id == details[i].id)
        return details[i];
    }
    return null;
  }

}
