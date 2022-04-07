import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:warehouse/device/models/checklist_model.dart';
import 'package:warehouse/device/models/database_helper.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:warehouse/common_widgets/textfield_widget.dart';

class AddWithoutUser extends StatefulWidget {
  final CheckList? checkList;
  final String? docId;
  const AddWithoutUser({
    Key? key,
    this.checkList,
    this.docId,
  }) : super(key: key);

  @override
  _AddWithoutUserScreenState createState() => _AddWithoutUserScreenState();
}

class _AddWithoutUserScreenState extends State<AddWithoutUser> {
  String? selectedValue;

  List<String> items = [
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
  ];
  TextEditingController deviceDescriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController serialNumberController = TextEditingController();
  TextEditingController operatingSystemController = TextEditingController();

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
            const TextWidget(text: 'Device Description'),
            const SizedBox(height: 10.0),
            TextFieldWidget(
                enabled: true,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                text: "Enter the make and model",
                controller: deviceDescriptionController),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Enter the device year'),
            Center(
              child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                isExpanded: true,
                hint: const Center(
                  child: Text(
                    'Select Year',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 131, 130, 130),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Center(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
              )),
            ),
            const TextWidget(text: 'Operating System'),
            const SizedBox(height: 10.0),
            TextFieldWidget(
                enabled: true,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                text: "Enter the operating system",
                controller: operatingSystemController),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Location'),
            const SizedBox(height: 10.0),
            TextFieldWidget(
                enabled: true,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                text: "Enter the current location of the device",
                controller: locationController),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Serial Number'),
            const SizedBox(height: 10.0),
            TextFieldWidget(
                enabled: true,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                text: "Enter the serial number",
                controller: serialNumberController),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  // print(nameController.text);
                  FocusScope.of(context).unfocus();
                  if (deviceDescriptionController.text.trim().isNotEmpty &&
                      locationController.text.trim().isNotEmpty &&
                      serialNumberController.text.trim().isNotEmpty) {
                    await DatabaseHelper.addCheckList(
                      name: "N/A",
                      jobTitle: "N/A",
                      year: "2020",
                      operatingSystem: operatingSystemController.text,
                      deviceDescription: deviceDescriptionController.text,
                      deviceLocation: locationController.text,
                      serial: serialNumberController.text,
                    );
                  }
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'ADD',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    deviceDescriptionController.dispose();
    locationController.dispose();
    serialNumberController.dispose();
    super.dispose();
  }
}
