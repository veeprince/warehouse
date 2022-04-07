import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  const TextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.aBeeZee(
        color: const Color.fromARGB(255, 143, 140, 140),
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
