part of 'app_state_bloc.dart';

sealed class AppStateState extends Equatable {
  const AppStateState();

  @override
  List<Object> get props => [];
}

final class AppStateInitial extends AppStateState {}

final class AppStateLoading extends AppStateState {}

final class AppStateLoggedIn extends AppStateState {
  const AppStateLoggedIn(this.authUser);

  final User authUser;

  @override
  List<Object> get props => [authUser];
}
