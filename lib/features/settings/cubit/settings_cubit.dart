import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';
import 'package:lotspot/repositories/settings_repository.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.settingsRepository, required this.authenticationRepository})
      : super(const SettingsState.loading());

  final SettingsRepository settingsRepository;
  final AuthenticationRepository authenticationRepository;

  Future<void> init() async {
    final authUser = authenticationRepository.getAuthUser();
    if (authUser == null) return;

    final settings = await settingsRepository.getUserSettings(authUser);
    emit(SettingsState.loaded(authUser, settings));
    _updateLocalSettings();
  }

  Future<void> updateUserSettings(String settingName, bool value) async {
    HapticFeedback.lightImpact();
    final authUser = authenticationRepository.getAuthUser();
    if (authUser == null) return;

    final settings = Map.from(state.settings).map((key, value) => MapEntry(key as String, value as bool));
    settings[settingName] = value;

    emit(SettingsState.loaded(authUser, settings));
    _updateLocalSettings();

    await settingsRepository.updateUserSettings(authUser, settingName, value);
  }

  Future<void> _updateLocalSettings() async {
    final settings = state.settings;

    if (settings['brightness_mode'] == true) {
      await ScreenBrightness().setScreenBrightness(1.0);
    } else {
      await ScreenBrightness().resetScreenBrightness();
    }

    if (settings['screen_alway_on'] == true) {
      KeepScreenOn.turnOn();
    } else {
      KeepScreenOn.turnOff();
    }
  }

  Future<void> shareApp() async {
    HapticFeedback.mediumImpact();
    await Share.share('https://lotspot.de', subject: 'Share LotSplot to your friends!');
  }

  Future<void> openMailApp() async {
    HapticFeedback.mediumImpact();
    await launchUrl(Uri.parse('tel:+4915209545443'));
  }

  Future<void> signOut() async {
    HapticFeedback.heavyImpact();
    authenticationRepository.signOut();
  }
}
