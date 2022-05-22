import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/screens/add_dishware_screen.dart';
import 'package:warehouse/dishware/screens/view_dishware_screen.dart';

import '../models/dishware_database_helper.dart';

// ignore: must_be_immutable
class ListDishwareItem extends StatelessWidget {
  final DishwareCheckList checkList;
  final String docId;
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  ListDishwareItem(this.checkList, this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
          child: Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
                color: const Color.fromARGB(31, 0, 0, 0),
                borderRadius: BorderRadius.circular(15)),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              CachedNetworkImage(
                height: 150,
                fit: BoxFit.contain,
                imageUrl: checkList.imageUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    LinearProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    checkList.name,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ]),
          ),
          // await showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         content: Text(
          //             "Are you sure you want to delete ${checkList.name}?"),
          //         actions: <Widget>[
          //           ElevatedButton(
          //             child: const Text(
          //               "No",
          //               style: TextStyle(color: Colors.black),
          //             ),
          //             onPressed: () {
          //               Navigator.of(context).pop();
          //             },
          //           ),
          //           ElevatedButton(
          //             child: const Text(
          //               "Yes",
          //               style: TextStyle(color: Colors.black),
          //             ),
          //             onPressed: () async {
          //               FirebaseFirestore.instance
          //                   .collection("Dishware")
          //                   .doc(docId)
          //                   .get()
          //                   .then((value) {
          //                 imageId = value.data()!["imageUrl"];
          //               }).whenComplete(() {
          //                 if (imageId == null) {
          //                   Timer.periodic(const Duration(microseconds: 1),
          //                       (timer) {
          //                     if (imageId != null) {
          //                       timer.cancel();
          //                       FirebaseStorage.instance
          //                           .refFromURL(imageId)
          //                           .delete();
          //                       DishwareDatabaseHelper.deleteChecklist(
          //                           docId: docId);
          //                     }
          //                   });
          //                 } else if (imageId != null) {
          //                   FirebaseStorage.instance
          //                       .refFromURL(imageId)
          //                       .delete();
          //                   DishwareDatabaseHelper.deleteChecklist(
          //                       docId: docId);
          //                 }
          //               });

          //               Navigator.of(context).pop();
          //             },
          //           ),
          //         ],
          //       ),);
          onDoubleTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Do you want to Edit ${checkList.name} or Delete?"),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddDishwareScreen(
                                            checkList: checkList,
                                            docId: docId,
                                          )))
                              .whenComplete(() => Navigator.of(context).pop());
                        },
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Delete",
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
          },
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewDishwareScreen(
                        checkList: checkList,
                        docId: docId,
                      )))),
    );
  }
}
