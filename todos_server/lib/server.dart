import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:todos_server/src/utils.dart';

import 'package:todos_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// add serverpod auth server
import 'package:serverpod_auth_server/module.dart' as auth;

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // If you are using any future calls, they need to be registered here.
  // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

  // auth via email
  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      // Send your validation email here.
      session.log('validationCode $validationCode');
      sendEmail(email, validationCode, session);
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      // Send a password reset email here.
      session.log('validationCode $validationCode');
      sendEmail(userInfo.email!, validationCode, session);
      return true;
    },
  ));

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(RouteStaticDirectory(serverDirectory: 'static'), '/static/*');

  // Start the server.
  await pod.start();
}
