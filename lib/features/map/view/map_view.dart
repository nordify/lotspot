import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/map/cubit/map_cubit.dart';

class SpotMapView extends StatefulWidget {
  const SpotMapView({super.key});

  @override
  State<SpotMapView> createState() => _SpotMapViewState();
}

class _SpotMapViewState extends State<SpotMapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return AppleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 19.5),
            mapType: MapType.standard,
            compassEnabled: false,
            polygons: state.polygons,
            annotations: state.annotations,
            myLocationEnabled: true,
            trackingMode: TrackingMode.followWithHeading,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => context.read<MapCubit>().onMapCreated(controller),
          );
        },
      ),
    );
  }
}
