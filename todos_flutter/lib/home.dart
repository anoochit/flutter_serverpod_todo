import 'package:flutter/material.dart';
import 'package:todos_flutter/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: [
          IconButton(
            onPressed: () {
              // signout
              sessionManager.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(),
    );
  }
}
