import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final String text;
  const ContainerWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      alignment: Alignment.center,
      child: Center(
        child: Text(text),
      ),
    );
  }
}
