import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.authenticationRepository}) : super(const HomeState.loading());

  AuthenticationRepository authenticationRepository;

  Future<void> onMapCreated(AppleMapController mapController) async {
    emit(HomeState.loaded(mapController));

  }

  Future<void> signOut() async {
    HapticFeedback.vibrate();
    authenticationRepository.signOut();
  }
}
