import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:warehouse/dishware/models/dishware_item.dart';
import 'package:warehouse/dishware/widgets/search_firebase.dart';

class DishwareFormField extends StatefulWidget {
  const DishwareFormField({Key? key}) : super(key: key);

  @override
  _DishwareFormFieldState createState() => _DishwareFormFieldState();
}

class _DishwareFormFieldState extends State<DishwareFormField> {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController productPositionController = TextEditingController();
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
      items: dishwareItems,
      onChanged: (val) {
        switch (val) {
          case 'name':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Dishware name'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: nameController,
                            onSubmitted: (nameController) {
                              FirebaseFirestore.instance
                                  .collection("Dishware")
                                  .where("name",
                                      isEqualTo: SearchFirebaseState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Dishware")
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
          case 'quantity':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Dishware Quantity'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: quantityController,
                            onSubmitted: (quantityController) {
                              FirebaseFirestore.instance
                                  .collection("Dishware")
                                  .where("name",
                                      isEqualTo: SearchFirebaseState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Dishware")
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

          case 'location':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input Product Location'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: locationController,
                            onSubmitted: (locationController) {
                              FirebaseFirestore.instance
                                  .collection("Dishware")
                                  .where("name",
                                      isEqualTo: SearchFirebaseState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Dishware")
                                      .doc(element.id)
                                      .update({
                                    'productLocation': locationController,
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
          case 'position':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Enter Product Position'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        TextField(
                            controller: productPositionController,
                            onSubmitted: (productPositionController) {
                              FirebaseFirestore.instance
                                  .collection("Dishware")
                                  .where("name",
                                      isEqualTo: SearchFirebaseState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Dishware")
                                      .doc(element.id)
                                      .update({
                                    'productPosition':
                                        productPositionController,
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
