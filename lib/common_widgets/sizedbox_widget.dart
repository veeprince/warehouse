import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SizedBoxWidget extends StatelessWidget {
  final String text;
  const SizedBoxWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: SelectableText(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.secularOne(
                fontSize: 20, color: const Color.fromARGB(255, 203, 202, 202)),
          ),
        ),
        const Divider(
          thickness: 1,
        )
      ],
    );
  }
}
