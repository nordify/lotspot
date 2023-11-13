import 'dart:async';
import 'dart:math';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lotspot/app/color_palette.dart';
import 'package:lotspot/features/map/model/spot.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';
import 'package:lotspot/repositories/spots_repository.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.spotsRepository}) : super(const MapState.loading());

  final SpotsRepository spotsRepository;
  late final StreamSubscription<List<DocumentSnapshot<Object?>>> _spotsUpdateStream;

  Future<void> onMapCreated(AppleMapController mapController) async {
    await _startSpotsUpdateStream();
    emit(MapState.loaded(mapController));
  }

  Future<void> _startSpotsUpdateStream() async {
    await Geolocator.checkPermission();
    final pos = await Geolocator.getCurrentPosition();
    final currentLocation = LatLng(pos.latitude, pos.longitude);

    _spotsUpdateStream = spotsRepository.getNearbySpotsUpdateStream(currentLocation).listen(
        (data) => _updateSpotsOnMap(data.map((e) => Spot.fromFirestoreMap(e.data() as Map<String, dynamic>)).toList()));
  }

  Future<void> _updateSpotsOnMap(List<Spot> spots) async {
    Set<Polygon> polygons = {};
    Set<Annotation> annotations = {};

    for (final spot in spots) {
      // Convert direction from degrees to radians
      double directionInRadians = spot.direction * (pi / 180.0);

      // Convert width and length from meters to degrees (approximate)
      double widthInDegrees = 6 / (111320 * cos(spot.location.latitude * (pi / 180.0)));
      double lengthInDegrees = 13 / 110540;

      // Calculate the coordinates of the rectangle corners
      LatLng corner1 =
          LatLng(spot.location.latitude + lengthInDegrees / 2, spot.location.longitude - widthInDegrees / 2);
      LatLng corner2 =
          LatLng(spot.location.latitude - lengthInDegrees / 2, spot.location.longitude - widthInDegrees / 2);
      LatLng corner3 =
          LatLng(spot.location.latitude - lengthInDegrees / 2, spot.location.longitude + widthInDegrees / 2);
      LatLng corner4 =
          LatLng(spot.location.latitude + lengthInDegrees / 2, spot.location.longitude + widthInDegrees / 2);

      // Rotate the rectangle corners based on the direction
      double cosDir = cos(directionInRadians);
      double sinDir = sin(directionInRadians);

      corner1 = _rotatePoint(spot.location, corner1, cosDir, sinDir);
      corner2 = _rotatePoint(spot.location, corner2, cosDir, sinDir);
      corner3 = _rotatePoint(spot.location, corner3, cosDir, sinDir);
      corner4 = _rotatePoint(spot.location, corner4, cosDir, sinDir);

      final color = spot.occupied ? Colors.red : columbiaBlue;

      final polygon = Polygon(
          polygonId: PolygonId(spot.name),
          strokeWidth: 1,
          fillColor: color,
          strokeColor: biceBlue,
          points: [corner1, corner2, corner3, corner4]);
      final annotation = Annotation(
        annotationId: AnnotationId(spot.name),
        position: LatLng(spot.location.latitude, spot.location.longitude),
        icon: BitmapDescriptor.markerAnnotationWithHue(HSVColor.fromColor(color).hue),
        draggable: false,
        infoWindow: InfoWindow(title: spot.name),
        visible: true,
      );

      annotations.add(annotation);
      polygons.add(polygon);
    }

    emit(state.updatePolygonsAndAnnotations(polygons, annotations));
  }

  LatLng _rotatePoint(GeoPoint center, LatLng point, double cosDir, double sinDir) {
    double x = point.longitude - center.longitude;
    double y = point.latitude - center.latitude;

    double rotatedX = x * cosDir - y * sinDir;
    double rotatedY = x * sinDir + y * cosDir;

    return LatLng(center.latitude + rotatedY, center.longitude + rotatedX);
  }

  @override
  Future<void> close() {
    _spotsUpdateStream.cancel();
    return super.close();
  }
}
