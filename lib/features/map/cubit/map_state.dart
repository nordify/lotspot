part of 'map_cubit.dart';

enum MapStatus { loading, loaded }

class MapState extends Equatable {
  const MapState._(
      {this.status = MapStatus.loading,
      this.mapController,
      this.polygons = const {},
      this.annotations = const {},
      this.spots = const [],
      this.selectedSpot = '',
      this.reservedSpot = '', this.reserveSecondsLeft = 0});

  const MapState.loading() : this._();

  const MapState.loaded(AppleMapController mapController)
      : this._(status: MapStatus.loaded, mapController: mapController);

  final MapStatus status;
  final AppleMapController? mapController;
  final Set<Polygon> polygons;
  final Set<Annotation> annotations;
  final List<Spot> spots;
  final String selectedSpot;
  final String reservedSpot;
  final int reserveSecondsLeft;

  MapState updatePolygonsAndAnnotations(Set<Polygon> polygons, Set<Annotation> annotations, List<Spot> spots) {
    return MapState._(
        status: status,
        mapController: mapController,
        polygons: polygons,
        annotations: annotations,
        spots: spots,
        selectedSpot: selectedSpot,
        reservedSpot: reservedSpot, reserveSecondsLeft: reserveSecondsLeft);
  }

  MapState updateSelectedSpot(String selectedSpot) {
    return MapState._(
        status: status,
        mapController: mapController,
        polygons: polygons,
        annotations: annotations,
        spots: spots,
        selectedSpot: selectedSpot,
        reservedSpot: reservedSpot, reserveSecondsLeft: reserveSecondsLeft);
  }

  MapState updateReservedSpot(String reservedSpot, int reserveSecondsLeft) {
    return MapState._(
        status: status,
        mapController: mapController,
        polygons: polygons,
        annotations: annotations,
        spots: spots,
        selectedSpot: '',
        reservedSpot: reservedSpot, reserveSecondsLeft: reserveSecondsLeft);
  }

  @override
  List<Object?> get props => [status, mapController, polygons, spots, selectedSpot, reservedSpot, reserveSecondsLeft];
}
