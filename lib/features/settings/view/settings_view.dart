import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/settings/cubit/settings_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          title: const Text(
            "Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: Image.network(state.authUser?.photoURL ??
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                            .image,
                        radius: 50,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 45,
                            child: FittedBox(
                              child: Text(
                                state.authUser?.displayName ?? 'username',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                        Text(state.authUser?.email ?? 'email')
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => context.read<SettingsCubit>().shareApp(),
                        child: const Row(
                          children: [
                            Icon(Icons.ios_share),
                            SizedBox(
                              width: 1,
                            ),
                            Text("Share LotSpot")
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () => context.read<SettingsCubit>().openMailApp(),
                        child: const Row(
                          children: [
                            Icon(Icons.contact_page_outlined),
                            SizedBox(
                              width: 1,
                            ),
                            Text("Contact Us")
                          ],
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 45,
                      child: FittedBox(
                        child: Text(
                          'Settings',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Full Brightness", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Switch(
                        value: state.settings['brightness_mode'] ?? false,
                        onChanged: (value) =>
                            context.read<SettingsCubit>().updateUserSettings('brightness_mode', value)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                    "The Full Brightness Button is a feature designed to enhance your screen viewing experience by maximizing the display's brightness when activated.",
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
                    Switch(
                        value: state.settings['screen_alway_on'] ?? false,
                        onChanged: (value) =>
                            context.read<SettingsCubit>().updateUserSettings('screen_alway_on', value)),
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
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                      onPressed: () => context.read<SettingsCubit>().signOut(),
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
