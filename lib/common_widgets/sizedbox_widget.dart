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
          height: 25,
          child: SelectableText(
            text,
            textAlign: TextAlign.center,
            // overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.aBeeZee(
              color: const Color.fromARGB(255, 255, 252, 252),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(
          thickness: 1,
        )
      ],
    );
  }
}
