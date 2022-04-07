import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/sizedbox_widget.dart';

import 'package:warehouse/device/models/checklist_model.dart';
import 'package:warehouse/common_widgets/text_widget.dart';

class ViewTodoScreen extends StatefulWidget {
  final CheckList? checkList;
  final String? docId;
  const ViewTodoScreen({
    Key? key,
    this.checkList,
    this.docId,
  }) : super(key: key);

  @override
  _ViewTodoScreenState createState() => _ViewTodoScreenState();
}

class _ViewTodoScreenState extends State<ViewTodoScreen> {
  late String name;
  late String jobTitle;
  late String deviceDescription;
  late String serial;
  late String location;
  late String year;
  late String operatingSystem;
  @override
  void initState() {
    if (widget.checkList != null) {
      name = widget.checkList!.name;
      jobTitle = widget.checkList!.jobTitle;
      deviceDescription = widget.checkList!.deviceDescription;
      location = widget.checkList!.deviceLocation;
      operatingSystem = widget.checkList!.operatingSystem;
      year = widget.checkList!.year;
      serial = widget.checkList!.serial;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TAG Inventory list"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            const TextWidget(text: 'Employee Name'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: name),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Job Title'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: jobTitle),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Device Description'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: deviceDescription),
            const TextWidget(text: 'Device Year'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: year),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Device Operating System'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: operatingSystem),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Location'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: location),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Serial Number'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: serial),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
