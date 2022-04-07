import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool enabled;
  const TextFieldWidget(
      {Key? key,
      required this.enabled,
      required this.text,
      required this.controller,
      required this.textInputAction,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
        padding: const EdgeInsets.all(14),
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        controller: controller,
        placeholder: text,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        enabled: enabled,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color.fromARGB(255, 157, 155, 155),
            )));
  }
}
