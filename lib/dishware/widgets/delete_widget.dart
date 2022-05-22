import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/dishware/models/dishware_database_helper.dart';
import 'package:warehouse/dishware/screens/dishware_home.dart';

// ignore: must_be_immutable
class DeleteWidget extends StatelessWidget {
  final String name;
  // ignore: prefer_typing_uninitialized_variables
  var docId;
  DeleteWidget(this.name, this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.delete),
        title: const Text('Delete'),
        onTap: () {
          // ignore: prefer_typing_uninitialized_variables
          var imageId;
          FirebaseFirestore.instance
              .collection("Dishware")
              .where("name", isEqualTo: name)
              .get()
              .then((value) {
            for (var element in value.docs) {
              FirebaseFirestore.instance.collection("Dishware").doc(element.id);
              docId = element.id;
            }
          }).whenComplete(() {
            FirebaseFirestore.instance
                .collection("Dishware")
                .doc(docId)
                .get()
                .then((value) {
              imageId = value.data()!["imageUrl"];
            });
          }).whenComplete(() {
            if (imageId == null) {
              Timer.periodic(const Duration(microseconds: 1), (timer) {
                if (imageId != null) {
                  timer.cancel();
                  FirebaseStorage.instance.refFromURL(imageId).delete();
                  DishwareDatabaseHelper.deleteChecklist(docId: docId);
                }
              });
            }
          }).whenComplete(() {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DishwareHomePage(),
                ),
                (route) => route.isFirst);
          });
        });
  }
}
