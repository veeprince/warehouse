import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/slide_left.dart';
import 'package:warehouse/common_widgets/slide_right.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/models/dishware_database_helper.dart';
import 'package:warehouse/dishware/screens/view_dishware_screen.dart';

import '../screens/add_dishware_screen.dart';

// ignore: must_be_immutable
class ListDishwareItem extends StatelessWidget {
  final DishwareCheckList checkList;
  final String docId;
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  ListDishwareItem(this.checkList, this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
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
                        "Are you sure you want to delete ${checkList.name}?"),
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
                              .collection("Dishware")
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
                                  DishwareDatabaseHelper.deleteChecklist(
                                      docId: docId);
                                }
                              });
                            } else if (imageId != null) {
                              FirebaseStorage.instance
                                  .refFromURL(imageId)
                                  .delete();
                              DishwareDatabaseHelper.deleteChecklist(
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
                    builder: (context) => AddDishwareScreen(
                          checkList: checkList,
                          docId: docId,
                        )));
          }
          return null;
        },
        child: InkWell(
            radius: 10,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 250,
                    width: 400,
                    child: Image.network(checkList.imageUrl),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewDishwareScreen(
                          checkList: checkList,
                          docId: docId,
                        )))));
  }
}
