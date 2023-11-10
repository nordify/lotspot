import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class SpotsRepository {
  Stream<List<DocumentSnapshot>> getNearbySpotsUpdateStream(LatLng currentLocation) {
    final geo = Geoflutterfire();

    // get the collection reference or query
    final collectionReference = FirebaseFirestore.instance.collection('spots');

    const double radius = 10;
    const String field = 'location';
    final center = geo.point(latitude: currentLocation.latitude, longitude: currentLocation.longitude);

    return geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);
  }
}
