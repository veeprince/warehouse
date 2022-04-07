import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/slide_left.dart';
import 'package:warehouse/common_widgets/slide_right.dart';
import 'package:warehouse/inventory/models/inventory_checklist_model.dart';
import 'package:warehouse/inventory/models/inventory_database_helper.dart';
import 'package:warehouse/inventory/screens/add_inventory_screen.dart';
import 'package:warehouse/inventory/screens/view_inventory_screen.dart';

// ignore: must_be_immutable
class ListInventoryItem extends StatelessWidget {
  final InventoryCheckList checkList;
  final String docId;

  ListInventoryItem(this.checkList, this.docId, {Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Dismissible(
        key: Key(checkList.name),
        background: const SlideRightWidget(),
        secondaryBackground: const SlideLeftWidget(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Are you sure you want to delete ${checkList.name}'s data?"),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection("Product")
                              .doc(docId)
                              .get()
                              .then((value) {
                            imageId = value.data()!["imageUrl"];
                          }).whenComplete(() {
                            if (imageId == null) {
                              Timer.periodic(const Duration(microseconds: 1),
                                  (timer) {
                                if (imageId != null) {
                                  timer.cancel();
                                  FirebaseStorage.instance
                                      .refFromURL(imageId)
                                      .delete();
                                  InventoryDatabaseHelper.deleteChecklist(
                                      docId: docId);
                                }
                              });
                            } else if (imageId != null) {
                              FirebaseStorage.instance
                                  .refFromURL(imageId)
                                  .delete();
                              InventoryDatabaseHelper.deleteChecklist(
                                  docId: docId);
                            }
                          });

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            return res;
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddInventoryScreen(
                          checkList: checkList,
                          docId: docId,
                        )));
          }
          return null;
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewInventoryScreen(
                          checkList: checkList,
                          docId: docId,
                        )));
          },
          title: Text(
            checkList.name,
            style: const TextStyle(fontSize: 18),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "Quantity: ${checkList.quantity}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: SizedBox(
            height: 50,
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
        ),
      ),
    );
  }
}
