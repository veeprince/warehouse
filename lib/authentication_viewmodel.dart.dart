import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/blocs/auth_block.dart';
import 'package:warehouse/dishware/screens/dishware_home.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late StreamSubscription<User?> loginStateSubscription;
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        // print(fbUser);
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(name: "/Page1"),
            builder: (context) => const DishwareHomePage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/tag_square_1-1300x1300.jpg'))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SignInButton(
                Buttons.Google,
                onPressed: () => authBloc.signInwithGoogle(),
              ),
              const SizedBox(
                height: 220,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text("Made by Vee"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
