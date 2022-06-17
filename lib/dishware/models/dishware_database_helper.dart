import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DishwareDatabaseHelper {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final CollectionReference _collectionReference =
      _firebaseFirestore.collection('Dishware');

  static Future<void> addDishwareCheckList({
    required String quantity,
    required String imageUrl,
    required String color,
    required Map<String, dynamic> locations,
    required Map<String, dynamic> tags,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "quantity": quantity,
      "imageUrl": imageUrl,
      "color": color,
      "locations": locations,
      "tags": tags,
    };

    await documentReferencer.set(data);
  }

  // var check2;
  static Future<void> updateDishwareChecklist({
    String? quantity,
    String? color,
    Map<String, dynamic>? locations,
    Map<String, dynamic>? tags,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);
    // print(documentReferencer.id);
    Map<String, dynamic> data = <String, dynamic>{
      "quantity": quantity,
      "color": color,
      "locations": locations,
      "tags": tags,
    };

    await documentReferencer.update(data).catchError((e) => Text(e));
  }

  static Future<void> updateDishwareChecklistImage({
    String? quantity,
    String? color,
    String? imageUrl,
    Map<String, dynamic>? locations,
    Map<String, dynamic>? tags,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "quantity": quantity.toString(),
      "color": color,
      "locations": locations,
      'imageUrl': imageUrl,
      "tags": tags,
    };

    await documentReferencer.update(data);
  }

  static Stream<QuerySnapshot> getDishwareChecklist() {
    CollectionReference checklistItemCollection = _collectionReference;

    return checklistItemCollection.orderBy('color').snapshots();
  }

  static Future<void> deleteChecklist({
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);
    await documentReferencer.delete();
    // .whenComplete(() => print('Dishware Deleted'))
    // .catchError((e) => print(e));
  }
}
