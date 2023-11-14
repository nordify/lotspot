import 'package:cloud_firestore/cloud_firestore.dart';

class Spot {
  final String name;
  final GeoPoint location;
  final int direction;
  final bool occupied;
  final bool reserved;

  Spot(this.name, this.location, this.direction, this.occupied, this.reserved);

  factory Spot.fromFirestoreMap(Map<String, dynamic> data) {
    return Spot(data['name'], data['location']['geopoint'], data['direction'], data['occupied'], data['reserved'] == true);
  }
}
