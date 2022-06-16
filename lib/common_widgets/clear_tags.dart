import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

// ignore: must_be_immutable
class ClearTagWidget extends StatelessWidget {
  TextfieldTagsController controller = TextfieldTagsController();
  ClearTagWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20.5,
      onPressed: () {
        controller.clearTags();
      },
      icon: const Icon(Icons.clear_rounded),
    );
  }
}
