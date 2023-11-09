import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authenticationRepository}) : super(LoginInitial());

  final AuthenticationRepository authenticationRepository;

  Future<void> signInWithApple() async {
    HapticFeedback.mediumImpact();
  }

  Future<void> signInWithGoogle() async {
    HapticFeedback.mediumImpact();
    await authenticationRepository.signInWithGoogle();
  }
}
