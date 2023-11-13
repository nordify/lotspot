import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/app/app_observer.dart';
import 'package:lotspot/app/app_router.dart';
import 'package:lotspot/bloc/app_state_bloc.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';
import 'package:lotspot/repositories/settings_repository.dart';
import 'package:lotspot/repositories/spots_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp();

  Bloc.observer = AppObserver();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => AuthenticationRepository(),
      ),
      RepositoryProvider(
        create: (context) => SpotsRepository(),
      ),
      RepositoryProvider(create: (context) => SettingsRepository(),)
    ],
    child: BlocProvider(
      lazy: false,
      create: (context) => AppStateBloc(),
      child: const LotSplotApp(),
    ),
  ));
}

class LotSplotApp extends StatelessWidget {
  const LotSplotApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LotSpot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      routerConfig: AppRouter(context).router,
    );
  }
}
