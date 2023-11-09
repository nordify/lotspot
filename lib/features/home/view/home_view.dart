import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotspot/features/home/cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("HELLO THERE!"),
            Container(height: 50,),
            TextButton(
              onPressed: () => context.read<HomeCubit>().signOut(),
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black),),
              child: const Text("Sign out", style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}
