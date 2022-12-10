import 'dart:developer';

import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:todos_client/todos_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:todos_flutter/home.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.

late SessionManager sessionManager;
late Client client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init serverpod client with session manager
  client = Client(
    'http://10.0.2.2:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  await sessionManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: SignInPage(),
    );
  }
}

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
