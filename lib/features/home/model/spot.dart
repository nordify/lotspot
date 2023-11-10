import 'package:apple_maps_flutter/apple_maps_flutter.dart';

class Spot {
  final String name;
  final LatLng location;
  final int direction;
  final bool occupied;

  Spot(this.name, this.location, this.direction, this.occupied);
}
