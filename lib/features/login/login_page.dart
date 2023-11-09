import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/login/cubit/login_cubit.dart';
import 'package:lotspot/features/login/view/login_view.dart';
import 'package:lotspot/repositories/authencitation_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authenticationRepository: context.read<AuthenticationRepository>()),
      child: const LoginView(),
    );
  }
}
