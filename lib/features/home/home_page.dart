import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/home/cubit/home_cubit.dart';
import 'package:lotspot/features/home/view/home_view.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(authenticationRepository: context.read<AuthenticationRepository>()),
      child: const HomeView(),
    );
  }
}
