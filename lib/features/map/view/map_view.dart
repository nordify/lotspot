import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/app/color_palette.dart';
import 'package:lotspot/features/map/cubit/map_cubit.dart';

class SpotMapView extends StatefulWidget {
  const SpotMapView({super.key});

  @override
  State<SpotMapView> createState() => _SpotMapViewState();
}

class _SpotMapViewState extends State<SpotMapView> {
  String _formatTime(int seconds) {
    int m, s;

    m = seconds ~/ 60;
    s = (seconds - m * 60);

    final String secondsLeft = s.toString().length < 2 ? '0$s' : s.toString();
    final String result = '${m}m ${secondsLeft}s';

    return result;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MapCubit>().brightnessUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 2,
          backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? columbiaBlue : oxfordBlue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40, child: Image.asset('assets/logo.png')),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'LotSpot',
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return Stack(
            children: [
              AppleMap(
                initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 19.5),
                mapType: MapType.standard,
                compassEnabled: false,
                polygons: state.polygons,
                annotations: state.annotations,
                myLocationEnabled: true,
                trackingMode: TrackingMode.followWithHeading,
                myLocationButtonEnabled: true,
                onTap: (_) => context.read<MapCubit>().resetSelectedSpot(),
                onMapCreated: (controller) => context.read<MapCubit>().onMapCreated(controller),
              ),
              if (state.reservedSpot.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: MediaQuery.of(context).platformBrightness == Brightness.light
                            ? Colors.orange[300]
                            : Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                          child: SizedBox(
                            height: 25,
                            child: FittedBox(
                              child: Text(
                                _formatTime(state.reserveSecondsLeft),
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (state.selectedSpot.isNotEmpty || state.reservedSpot.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: MediaQuery.of(context).padding.bottom + 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () => context.read<MapCubit>().getDirectionsToSpot(),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.navigation_outlined),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("Get Directions")
                                  ],
                                )))),
                    if (state.selectedSpot.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 7.5,),
                          SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () => context.read<MapCubit>().resverveSpot(context),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.schedule_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Reserve Spot")
                                    ],
                                  ))),
                        ],
                      ),          
                    if (state.reservedSpot.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 7.5,),
                          SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () => context.read<MapCubit>().cancelReservation(context),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cancel_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Cancel Reservation")
                                    ],
                                  ))),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
