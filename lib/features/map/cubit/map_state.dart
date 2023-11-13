part of 'map_cubit.dart';

enum MapStatus { loading, loaded }

class MapState extends Equatable {
  const MapState._(
      {this.status = MapStatus.loading, this.mapController, this.polygons = const {}, this.annotations = const {}});

  const MapState.loading() : this._();

  const MapState.loaded(AppleMapController mapController)
      : this._(status: MapStatus.loaded, mapController: mapController);

  final MapStatus status;
  final AppleMapController? mapController;
  final Set<Polygon> polygons;
  final Set<Annotation> annotations;

  MapState updatePolygonsAndAnnotations(Set<Polygon> polygons, Set<Annotation> annotations) {
    return MapState._(status: status, mapController: mapController, polygons: polygons, annotations: annotations);
  }

  @override
  List<Object?> get props => [status, mapController, polygons];
}
