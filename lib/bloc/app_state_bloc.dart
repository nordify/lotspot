import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'app_state_event.dart';
part 'app_state_state.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppStateState> with ChangeNotifier {
  AppStateBloc() : super(AppStateLoading()) {
    on<_AuthStreamChange>(_onAuthStreamChange);

    _authUserStream = FirebaseAuth.instance.authStateChanges().listen((authUser) => add(_AuthStreamChange(authUser)));
  }

  late final StreamSubscription<User?> _authUserStream;

  Future<void> _onAuthStreamChange(_AuthStreamChange authStreamChange, Emitter<AppStateState> emit) async {
    final authUser = authStreamChange.authUser;

    if (authUser == null) {
      emit(AppStateInitial());
      notifyListeners();
      return;
    }

    emit(AppStateLoggedIn(authUser));
    notifyListeners();
    return;
  }

  @override
  Future<void> close() {
    _authUserStream.cancel();
    return super.close();
  }
}
