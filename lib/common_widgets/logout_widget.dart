import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/blocs/auth_block.dart';

class GoogleLogout extends StatelessWidget {
  const GoogleLogout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          buttonPadding: EdgeInsets.zero,
          backgroundColor: Colors.grey[900],
          contentPadding: EdgeInsets.zero,
          content: SignInButton(
            Buttons.Google,
            text: "Log Out",
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            onPressed: () {
              authBloc.logout();
              // Navigator.of(context).pop();
            },
          ),
          actions: const <Widget>[],
        ),
      ],
    );
  }
}
