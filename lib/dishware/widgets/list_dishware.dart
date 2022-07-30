import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/screens/add_dishware_screen.dart';
import 'package:warehouse/dishware/screens/view_dishware_screen.dart';
import 'package:warehouse/dishware/widgets/search_page1.dart';
import 'package:warehouse/functions.dart';
import '../models/dishware_database_helper.dart';

// ignore: must_be_immutable
class ListDishwareItem extends StatefulWidget {
  final DishwareCheckList checkList;
  final String docId;

  const ListDishwareItem(this.checkList, this.docId, {Key? key})
      : super(key: key);

  @override
  State<ListDishwareItem> createState() => _ListDishwareItemState();
}

class _ListDishwareItemState extends State<ListDishwareItem>
    with DishFunctions {
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  TextEditingController textFieldController = TextEditingController();
  TextEditingController locationTextFieldController = TextEditingController();
  String valueText = '';
  late String codeDialog;

  String locationText = '';
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          height: 150,
          // width: 50,
          decoration: BoxDecoration(
              color: const Color.fromARGB(256, 50, 50, 50),
              borderRadius: BorderRadius.circular(15)),
          child: Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 150,
                    width: 165,
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.checkList.imageUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            LinearProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Quantity: ${widget.checkList.quantity}",
                style: const TextStyle(
                    fontSize: 13, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            // const Divider(
            //   endIndent: 18,
            //   thickness: 2,
            //   height: 1,
            //   indent: 18,
            // )
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
                  content: const Text(
                    "What would you like to do?",
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                                          checkList: widget.checkList,
                                          docId: widget.docId,
                                        ))).then((value) =>
                                Navigator.of(context)
                                    .popUntil(ModalRoute.withName("/Page1")));
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
                                .doc(widget.docId)
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
                                        docId: widget.docId);
                                  }
                                });
                              } else if (imageId != null) {
                                FirebaseStorage.instance
                                    .refFromURL(imageId)
                                    .delete();
                                DishwareDatabaseHelper.deleteChecklist(
                                    docId: widget.docId);
                              }
                            });

                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                            child: const Text(
                              "Request",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection("Dishware")
                                  .doc(widget.docId)
                                  .get()
                                  .then((value) {
                                imageId = value.data()!["imageUrl"];
                              }).whenComplete(
                                () {
                                  _displayTextInputDialog(context)
                                      .whenComplete(() async => {
                                            // print(imageId),
                                            if (valueText.isNotEmpty &&
                                                locationText.isNotEmpty)
                                              {
                                                await sendEmail(valueText,
                                                    imageId, locationText)
                                              }
                                          })
                                      .whenComplete(() => {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackbarRenderer(
                                                    "Hurray",
                                                    "Facilities have been notified of your request",
                                                    ContentType.success))
                                          })
                                      .whenComplete(
                                          () => Navigator.of(context).pop());
                                },
                              );
                            })
                      ],
                    ),
                  ],
                );
              });
        },
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewDishwareScreen(
                      checkList: widget.checkList,
                      docId: widget.docId,
                    ))));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Quantity and Location'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      valueText = value;
                    });
                  },
                  controller: textFieldController,
                  decoration: const InputDecoration(hintText: "Quantity"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      locationText = value;
                    });
                  },
                  controller: locationTextFieldController,
                  decoration:
                      const InputDecoration(hintText: "Delivery Location"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('REQUEST'),
                onPressed: () {
                  if (valueText.isEmpty || locationText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(snackbarRenderer(
                        "Ooops",
                        "Please enter a quantity or a delivery location",
                        ContentType.warning));
                  } else {
                    setState(() {
                      codeDialog = valueText;
                      Navigator.pop(context);
                      textFieldController.clear();
                      locationTextFieldController.clear();
                    });
                  }
                },
              ),
            ],
          );
        });
  }
}
