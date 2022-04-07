import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final CollectionReference _collectionReference =
      _firebaseFirestore.collection('Device');

  static Future<void> addCheckList({
    required String name,
    required String jobTitle,
    required String deviceDescription,
    required String deviceLocation,
    required String operatingSystem,
    required String serial,
    required String year,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc();

    Map<String, dynamic> data = <String, dynamic>{
      // "title": title,
      // "description": description,

      "name": name,
      "jobTitle": jobTitle,
      "deviceDescription": deviceDescription,
      "deviceLocation": deviceLocation,
      "operatingSystem": operatingSystem,
      "serial": serial,
      "year": year,
    };

    await documentReferencer.set(data);
    // .whenComplete(() => Text("Device added"))
    // .catchError((e) => print(e));
  }

  static Future<void> updateChecklist({
    required String name,
    required String jobTitle,
    required String deviceLocation,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "jobTitle": jobTitle,
      "deviceLocation": deviceLocation,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => const AlertDialog(
              title: Text("Status"),
              content: Text("Device Updated"),
              actions: [
                CupertinoDialogAction(
                  child: Text("OK"),
                ),
              ],
            ))
        // ignore: avoid_print
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> getChecklist() {
    CollectionReference checklistItemCollection = _collectionReference;

    return checklistItemCollection.orderBy('deviceDescription').snapshots();
  }

  static Future<void> deleteChecklist({
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);

    await documentReferencer.delete();
  }
}
