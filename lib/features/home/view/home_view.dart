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
      body: AppleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(37.89155, -4.77275), zoom: 14),
        mapType: MapType.standard,
        onMapCreated: (controller) => context.read<HomeCubit>().onMapCreated(controller),
      ),
    );
  }
}
