import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:warehouse/device/models/device_item.dart';
import 'package:warehouse/device/widgets/show_search.dart';

class ShowFormField extends StatefulWidget {
  const ShowFormField({Key? key}) : super(key: key);

  @override
  _ShowFormFieldState createState() => _ShowFormFieldState();
}

class _ShowFormFieldState extends State<ShowFormField> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController deviceDescriptionController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SelectFormField(
      type: SelectFormFieldType.dropdown, // or can be dialog
      initialValue: 'Name',
      icon: const Icon(Icons.update),
      // textAlignVertical: TextAlignVertical.center,
      labelText: 'Update',
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      items: deviceItem,
      onChanged: (val) {
        switch (val) {
          case 'name':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Employee name'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: nameController,
                            onSubmitted: (nameController) {
                              FirebaseFirestore.instance
                                  .collection("Device")
                                  .where("name",
                                      isEqualTo: ShowSearchState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Device")
                                      .doc(element.id)
                                      .update({
                                    'name': nameController,
                                  });
                                }
                              });
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
            break;
          case 'jobTitle':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Job Title'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: jobTitleController,
                            onSubmitted: (jobTitleController) {
                              FirebaseFirestore.instance
                                  .collection("Device")
                                  .where("name",
                                      isEqualTo: ShowSearchState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Device")
                                      .doc(element.id)
                                      .update({
                                    'jobTitle': jobTitleController,
                                  });
                                }
                              });
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
            break;
          case 'deviceDescription':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Device Description'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: deviceDescriptionController,
                            onSubmitted: (deviceDescription) {
                              FirebaseFirestore.instance
                                  .collection("Device")
                                  .where("name",
                                      isEqualTo: ShowSearchState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Device")
                                      .doc(element.id)
                                      .update({
                                    'deviceDescription': deviceDescription,
                                  });
                                }
                              });
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
            break;
          case 'location':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Device Location'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: locationController,
                            onSubmitted: (locationController) {
                              FirebaseFirestore.instance
                                  .collection("Device")
                                  .where("name",
                                      isEqualTo: ShowSearchState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Device")
                                      .doc(element.id)
                                      .update({
                                    'deviceLocation': locationController,
                                  });
                                }
                              });
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
            break;
          case 'quantity':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Quantity'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: quantityController,
                            onSubmitted: (quantityController) {
                              FirebaseFirestore.instance
                                  .collection("Device")
                                  .where("name",
                                      isEqualTo: ShowSearchState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Device")
                                      .doc(element.id)
                                      .update({
                                    'quantity': quantityController,
                                  });
                                }
                              });
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
            break;
          default:
            const Text('Error');
        }
      },
    );
  }
}
