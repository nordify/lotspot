import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class SpotsRepository {
  Stream<List<DocumentSnapshot>> getNearbySpotsUpdateStream(LatLng currentLocation) {
    final geo = Geoflutterfire();

    // get the collection reference or query
    final collectionReference = FirebaseFirestore.instance.collection('spots');

    const double radius = 50;
    const String field = 'location';
    final center = geo.point(latitude: currentLocation.latitude, longitude: currentLocation.longitude);

    return geo.collection(collectionRef: collectionReference).within(center: center, radius: radius, field: field);
  }

  Future<void> updateReserveSpot(String spotName, bool reserved) async {
    final results =
        await FirebaseFirestore.instance.collection('spots').where('name', isEqualTo: spotName).limit(1).get();
    if (results.docs.isEmpty) return;
    
    final id = results.docs.first.id;
    await FirebaseFirestore.instance.collection('spots').doc(id).update({'reserved': reserved});
  }
}
