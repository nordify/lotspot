import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/settings/cubit/settings_cubit.dart';
import 'package:lotspot/features/settings/view/settings_view.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';
import 'package:lotspot/repositories/settings_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(settingsRepository: context.read<SettingsRepository>(), authenticationRepository: context.read<AuthenticationRepository>())..init(),
      child: const SettingsView(),
    );
  }
}
