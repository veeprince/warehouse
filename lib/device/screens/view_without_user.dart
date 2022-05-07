import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/blocs/auth_block.dart';
import 'package:warehouse/blocs/google_auth_api.dart';
import 'package:warehouse/common_widgets/slide_left.dart';
import 'package:warehouse/common_widgets/slide_right.dart';
import 'package:warehouse/device/screens/view_screen.dart';

import 'add_with_user.dart';
import '../models/checklist_model.dart';
import '../models/database_helper.dart';

class ListWithoutUser extends StatefulWidget {
  final CheckList checkList;
  final String docId;

  // ignore: use_key_in_widget_constructors
  const ListWithoutUser(this.checkList, this.docId);

  @override
  State<ListWithoutUser> createState() => _ListWithoutUserState();
}

class _ListWithoutUserState extends State<ListWithoutUser> {
  // Future sendEmail() async {
  //   // final user = await GoogleAuthApi.signIn();
  //   if (user == null) {
  //     print('Empty');
  //     return;
  //   }
  //   ;

  //   final email = user.email;
  //   final auth = await user.authentication;
  //   final token = auth.accessToken!;
  //   final smtpServer = gmailSaslXoauth2(email, token);
  //   final message = Message()
  //     ..from = Address(email, 'Bolu')
  //     ..recipients = ['bolu.akinwande@thealineagroup.com']
  //     ..subject = "Hello"
  //     ..text = "Test";
  //   try {
  //     await send(message, smtpServer);
  //     showSnackBar('Sent email successfully');
  //   } on MailerException catch (e) {
  //     print(e);
  //   }
  // }

  void showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.green,
    );
  }

  // void sendEmail(String emailAddress) async {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    late String username;

    authBloc.currentUser.forEach((element) {
      username = element!.email!;
      print(username);
    });
    // print(username);
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Dismissible(
        key: Key(widget.checkList.name),
        background: const SlideRightWidget(),
        secondaryBackground: const SlideLeftWidget(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Are you sure you want to delete ${widget.checkList.name}'s data?"),
                    actions: <Widget>[
                      Center(
                        child: Row(
                          children: [
                            ElevatedButton(
                              child: const Text(
                                "No",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(
                              width: 200,
                            ),
                            ElevatedButton(
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                DatabaseHelper.deleteChecklist(
                                    docId: widget.docId);
                                // FirebaseStorage.instance.refFromURL(url)
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
            return res;
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTodoScreen(
                          checkList: widget.checkList,
                          docId: widget.docId,
                        ),
                    fullscreenDialog: true));
          }
          return null;
        },
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewTodoScreen(
                              checkList: widget.checkList,
                              docId: widget.docId,
                            )));
                //Show all the list without editing it
              },
              title: Text(
                widget.checkList.deviceDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 30.0),
              ),
              subtitle: Text(
                widget.checkList.name,
                overflow: TextOverflow.ellipsis,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              trailing: Text(
                widget.checkList.deviceLocation,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  // await sendEmail();
                },
                child: const Text(
                  "REQUEST",
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
