
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/map/cubit/map_cubit.dart';
import 'package:lotspot/features/map/view/map_view.dart';
import 'package:lotspot/repositories/spots_repository.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit(
          spotsRepository: context.read<SpotsRepository>()),
      child: const SpotMapView(),
    );
  }
}
