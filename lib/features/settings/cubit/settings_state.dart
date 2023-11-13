part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState._({this.settings = const {}});

  const SettingsState.loading() : this._();

  const SettingsState.loaded(Map<String, bool> settings) : this._(settings: settings);

  final Map<String, bool> settings;

  @override
  List<Object> get props => [settings];
}
