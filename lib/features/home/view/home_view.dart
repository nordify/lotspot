import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/home/cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return AppleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(0,0), zoom: 15.5),
            mapType: MapType.standard,
            compassEnabled: false,
            trackingMode: TrackingMode.followWithHeading,
            polygons: state.polygons,
            onMapCreated: (controller) => context.read<HomeCubit>().onMapCreated(controller),
          );
        },
      ),
    );
  }
}
