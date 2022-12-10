import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

import 'package:todos_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

import 'dart:io';

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
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      // Send a password reset email here.
      session.log('validationCode $validationCode');
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

sendEmail(String email, String validationCode, Session session) async {
  // TODO : send mail to mailhog
  final smtpServer = SmtpServer(
    '10.0.2.2',
    port: 1025,
    allowInsecure: true,
  );

  final body = "Your validation code is $validationCode ";

  final message = Message()
    ..from = Address("no-reply@example.com", "no-reply")
    ..recipients.add(email)
    ..subject = 'Validation code'
    ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    session.log('Send mail error ${sendReport}');
  } on MailerException catch (e) {
    session.log('Message not sent: ${e.problems}');
  }
}
