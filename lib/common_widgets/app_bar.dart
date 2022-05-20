import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/blocs/auth_block.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StreamBuilder<User?>(
            stream: authBloc.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, //remove this when you add image.
                  ),
                  child: InkWell(
                    child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!.photoURL!)),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
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
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 8, bottom: 8),
                                    onPressed: () {
                                      authBloc.logout();
                                    },
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
              );
            }),
      ],
    );
  }
}
