import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:sprintmap/bloc/nav_drawer_bloc.dart';
import 'package:sprintmap/bloc/nav_drawer_state.dart';
import 'package:sprintmap/bloc/drawer_event.dart';

class QuestionsView extends StatelessWidget {
  const QuestionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              IconlyBold.category,
              size: 100,
            ),
            const Text(
              "Order View",
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
            TextButton(
              onPressed: () {
                context.read<NavDrawerBloc>().add(const NavigateTo(NavItem.todoView));
              },
              child: const Text("Go To Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
