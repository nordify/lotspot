part of 'home_cubit.dart';

enum HomeStatus { loading, loaded }

class HomeState extends Equatable {
  const HomeState._({this.status = HomeStatus.loading, this.mapController, this.polygons = const {}});

  const HomeState.loading() : this._();

  const HomeState.loaded(AppleMapController mapController, Set<Polygon> polygons)
      : this._(status: HomeStatus.loaded, mapController: mapController, polygons: polygons);

  final HomeStatus status;
  final AppleMapController? mapController;
  final Set<Polygon> polygons;

  @override
  List<Object?> get props => [status, mapController, polygons];
}
