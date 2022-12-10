import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:todos_flutter/main.dart';

import 'home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // lisen session change
  @override
  void initState() {
    super.initState();
    sessionManager.addListener(() {
      setState(() {
        log("session change status");
      });
    });
  }

  // remove stream connection when terminate state
  @override
  void dispose() {
    super.dispose();
    client.removeStreamingConnectionStatusListener(
      () {
        setState(() {
          log("remove session");
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // if signed in return homepage
    if (sessionManager.isSignedIn) {
      return HomePage();
    } else {
      // return signin page
      return Scaffold(
        body: Center(
          child: SignInWithEmailButton(caller: client.modules.auth),
        ),
      );
    }
  }
}
