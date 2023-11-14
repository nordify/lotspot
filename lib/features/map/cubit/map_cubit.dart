import 'dart:async';
import 'dart:math';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lotspot/app/color_palette.dart';
import 'package:lotspot/features/map/model/spot.dart';
import 'package:lotspot/repositories/spots_repository.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.spotsRepository}) : super(const MapState.loading());

  final SpotsRepository spotsRepository;
  late final StreamSubscription<List<DocumentSnapshot<Object?>>> _spotsUpdateStream;
  Timer? _timer;

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
      if (spot.reserved && state.reservedSpot.isEmpty) continue;
      if (state.reservedSpot.isNotEmpty && state.reservedSpot != spot.name) continue;

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

      final lightmode = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.light;
      final color = state.reservedSpot.isNotEmpty
          ? (lightmode ? Colors.orange[300]! : Colors.orange)
          : spot.occupied
              ? (lightmode ? Colors.red[200]! : Colors.red)
              : (lightmode ? columbiaBlue : sapphire);
      final borderColor = state.reservedSpot.isNotEmpty
          ? (lightmode ? Colors.orange : Colors.orange[900]!)
          : spot.occupied
              ? (lightmode ? Colors.red : Colors.red[900]!)
              : (lightmode ? biceBlue : oxfordBlue);

      final polygon = Polygon(
          polygonId: PolygonId(spot.name),
          strokeWidth: 1,
          fillColor: color,
          strokeColor: borderColor,
          points: [corner1, corner2, corner3, corner4]);
      final annotation = Annotation(
        annotationId: AnnotationId(spot.name),
        position: LatLng(spot.location.latitude, spot.location.longitude),
        icon: BitmapDescriptor.markerAnnotationWithHue(HSVColor.fromColor(color).hue),
        draggable: false,
        infoWindow: InfoWindow(title: spot.name),
        visible: true,
        onTap: () {
          HapticFeedback.lightImpact();
          state.mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(spot.location.latitude, spot.location.longitude), zoom: 25)));
          _selectSpot(spot.name);
        },
      );

      annotations.add(annotation);
      polygons.add(polygon);
    }

    emit(state.updatePolygonsAndAnnotations(polygons, annotations, spots));
  }

  LatLng _rotatePoint(GeoPoint center, LatLng point, double cosDir, double sinDir) {
    double x = point.longitude - center.longitude;
    double y = point.latitude - center.latitude;

    double rotatedX = x * cosDir - y * sinDir;
    double rotatedY = x * sinDir + y * cosDir;

    return LatLng(center.latitude + rotatedY, center.longitude + rotatedX);
  }

  Future<void> _selectSpot(String annotationId) async {
    emit(state.updateSelectedSpot(annotationId));
  }

  Future<void> resetSelectedSpot() async {
    emit(state.updateSelectedSpot(''));
  }

  Future<void> resverveSpot() async {
    if (state.selectedSpot.isEmpty) return;
    final annotationId = state.selectedSpot;

    emit(state.updateReservedSpot(annotationId, 600));
    HapticFeedback.heavyImpact();
    spotsRepository.updateReserveSpot(annotationId, true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.reserveSecondsLeft < 2) {
        _timer?.cancel();
        _timer = null;

        emit(state.updateReservedSpot('', 0));
        HapticFeedback.vibrate();
        spotsRepository.updateReserveSpot(annotationId, false);
        return;
      }

      emit(state.updateReservedSpot(annotationId, state.reserveSecondsLeft - 1));
      HapticFeedback.selectionClick();
    });
  }

  Future<void> cancelReservation() async {
    if (state.reservedSpot.isEmpty) return;
    _timer?.cancel();
    _timer = null;
    spotsRepository.updateReserveSpot(state.reservedSpot, false);
    if (isClosed) return;
    emit(state.updateReservedSpot('', 0));
    HapticFeedback.mediumImpact();
  }

  Future<void> brightnessUpdate() async {
    await _updateSpotsOnMap(state.spots);
  }

  @override
  Future<void> close() {
    _spotsUpdateStream.cancel();
    cancelReservation();
    return super.close();
  }
}
