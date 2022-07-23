import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:warehouse/blocs/google_auth_api.dart';

mixin DishFunctions {
  Future sendEmail(amount, url, location) async {
    GoogleAuthApi.signOut();
    // return;
    final user = await GoogleAuthApi.signIn();
    // print(user);
    if (user == null) return;

    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken!;
    // GoogleAuthApi.signOut();

    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = Address(email, user.displayName)
      ..recipients = [dotenv.env['EMAIL']]
      ..subject = "Dishware Request"
      ..html =
          '<p>${user.displayName} would like $amount of these dishware delivered to $location.</p><img src="$url" width="500" height="600">'
      ..text = "$amount amount";

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
