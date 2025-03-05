import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:sprintmap/bloc/nav_drawer_bloc.dart';
import 'package:sprintmap/bloc/nav_drawer_state.dart';
import 'package:sprintmap/bloc/drawer_event.dart';

class AiView extends StatelessWidget {
  const AiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              IconlyBold.bag_2,
              size: 100,
            ),
            const Text(
              "Cart View",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "It can be a stateless or stateful class. You can place any content or widgets you need within this page class.",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              color: const Color.fromARGB(255, 112, 119, 249),
              child: const Text("View All Orders"),
              onPressed: () {
                context.read<NavDrawerBloc>().add(const NavigateTo(NavItem.questionsView));
              },
            ),
            TextButton(
              onPressed: () {
                context.read<NavDrawerBloc>().add(const NavigateTo(NavItem.homeView));
              },
              child: const Text("Back To Home"),
            ),
          ],
        ),
      ),
    );
  }
}
