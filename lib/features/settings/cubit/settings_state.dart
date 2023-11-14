part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState._({this.authUser, this.settings = const {}});

  const SettingsState.loading() : this._();

  const SettingsState.loaded(User authUser, Map<String, bool> settings) : this._(authUser: authUser, settings: settings);

  final User? authUser;
  final Map<String, bool> settings;

  @override
  List<Object?> get props => [authUser, settings];
}
