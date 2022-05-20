import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/blocs/auth_block.dart';
import 'package:warehouse/spashScreen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => AuthBloc(),
        child: MaterialApp(
            theme: ThemeData(
              fontFamily: GoogleFonts.aBeeZee().fontFamily,
              primarySwatch: Colors.grey,
              brightness: Brightness.dark,
              pageTransitionsTheme: const PageTransitionsTheme(),
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen()));
  }
}
