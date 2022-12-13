import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/server.dart';

sendEmail(String email, String validationCode, Session session) async {
  // TODO : send mail to mailhog
  final smtpServer = SmtpServer(
    'smtp-relay.sendinblue.com',
    port: 587,
    username: 'anoochit@gmail.com',
    password: 'jBTxJafpNMzrFSVI',
  );

  final message = Message()
    ..from = Address("no-reply@example.com", "no-reply")
    ..recipients.add(email)
    ..subject = 'Validation code'
    ..text = "Your validation code is $validationCode"
    ..html = "<h1>Validation code</h1>\n<p>Your validation code is $validationCode</p>";

  try {
    final sendReport = await send(message, smtpServer);
    session.log('Send mail ${sendReport}');
  } on MailerException catch (e) {
    session.log('Message not sent: ${e.problems}');
  }
}
