import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text("Home Page Title"),
      ),
      body: Center(
        child: Text(
          "Home page content",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black87,
              ),
        ),
      ),
    );
  }
}
