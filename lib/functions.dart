import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
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

  renderWidget(String condition) {
    return Text(
      condition,
      style: GoogleFonts.aBeeZee(
        decoration: TextDecoration.none,
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  snackbarRenderer(String title, String message, ContentType contentType) {
    return SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: contentType,
      ),
    );
  }

  final List<String> colorItems = [
    'Any',
    'Yellow',
    'Green',
    'Red',
    'Blue',
    'Brown',
    'Black',
    'Pink',
    'Orange',
    'White',
    'Gold',
    'Glass',
    'Wood'
  ];
  final List<String> userList = [
    dotenv.env['TIM']!,
    dotenv.env['BOLU_PERSONAL_EMAIL']!,
    dotenv.env['BOLU_WORK_EMAIL']!,
  ];
}
