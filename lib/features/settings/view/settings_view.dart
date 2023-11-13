import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/app/color_palette.dart';
import 'package:lotspot/features/settings/cubit/settings_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          backgroundColor: oxfordBlue,
          foregroundColor: Colors.white,
          title: const Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Full Brightness", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Switch.adaptive(
                        value: state.settings['brightness_mode'] ?? false,
                        onChanged: (value) =>
                            context.read<SettingsCubit>().updateUserSettings('brightness_mode', value),
                        activeColor: sapphire),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                    "The Full Brightness Button is a convenient feature designed to enhance your screen viewing experience by maximizing the display's brightness when activated. With just a simple press, you can instantly achieve optimal visibility, making it ideal for situations where you need a brighter screen, such as working in well-lit environments or enjoying multimedia content in vibrant detail. ",
                    style: TextStyle(fontSize: 16),
                    softWrap: true),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Keep Screen On",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Switch.adaptive(
                        value: state.settings['screen_alway_on'] ?? false,
                        onChanged: (value) =>
                            context.read<SettingsCubit>().updateUserSettings('screen_alway_on', value),
                        activeColor: sapphire),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                    "The Keep Screen On Button is a convenient tool that ensures your screen stays on and prevents it from automatically turning off. ",
                    style: TextStyle(fontSize: 16),
                    softWrap: true),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: () => context.read<SettingsCubit>().signOut(),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: prussianBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
