// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:warehouse/inventory/models/inventory_item.dart';
import 'package:warehouse/inventory/widgets/search_widget.dart';

// ignore: must_be_immutable
class InventoryForm extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController productPositionController = TextEditingController();

  InventoryForm({Key? key}) : super(key: key);
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
      items: inventoryItems,
      onChanged: (val) {
        switch (val) {
          case 'name':
            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!

              builder: (BuildContext context) {
                return new AlertDialog(
                  title: const Text('Input Product name'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: [
                        new TextField(
                            controller: nameController,
                            onSubmitted: (nameController) {
                              FirebaseFirestore.instance
                                  .collection("Product")
                                  .where("name",
                                      isEqualTo: SearchInventoryState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Product")
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
                return new AlertDialog(
                  title: const Text('Input Product Quantity'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: [
                        new TextField(
                            controller: quantityController,
                            onSubmitted: (quantityController) {
                              FirebaseFirestore.instance
                                  .collection("Product")
                                  .where("name",
                                      isEqualTo: SearchInventoryState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Product")
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
                return new AlertDialog(
                  title: const Text('Input Product Location'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: [
                        new TextField(
                            controller: locationController,
                            onSubmitted: (locationController) {
                              FirebaseFirestore.instance
                                  .collection("Product")
                                  .where("name",
                                      isEqualTo: SearchInventoryState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Product")
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
                return new AlertDialog(
                  title: const Text('Enter Product Position'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: [
                        new TextField(
                            controller: productPositionController,
                            onSubmitted: (productPositionController) {
                              FirebaseFirestore.instance
                                  .collection("Product")
                                  .where("name",
                                      isEqualTo: SearchInventoryState().name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("Product")
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
