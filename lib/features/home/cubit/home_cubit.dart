import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.authenticationRepository}) : super(HomeInitial());

  AuthenticationRepository authenticationRepository;

  Future<void> signOut() async {
    HapticFeedback.vibrate();
    authenticationRepository.signOut();
  }
}
