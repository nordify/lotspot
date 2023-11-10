part of 'home_cubit.dart';

enum HomeStatus { loading, loaded }

class HomeState extends Equatable {
  const HomeState._({this.status = HomeStatus.loading, this.mapController});

  const HomeState.loading() : this._();

  const HomeState.loaded(AppleMapController mapController)
      : this._(status: HomeStatus.loaded, mapController: mapController);

  final HomeStatus status;
  final AppleMapController? mapController;

  @override
  List<Object?> get props => [status, mapController];
}

