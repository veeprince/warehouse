import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DishwareDatabaseHelper {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final CollectionReference _collectionReference =
      _firebaseFirestore.collection('Dishware');

  static Future<void> addDishwareCheckList(
      {required String name,
      required String quantity,
      required String color,
      required String productPosition,
      required String imageUrl,
      required Map<String, dynamic> tags,
      required String size}) async {
    DocumentReference documentReferencer = _collectionReference.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "color": color,
      "productPosition": productPosition,
      "imageUrl": imageUrl,
      "size": size,
      "tags": tags,
    };

    await documentReferencer.set(data);
  }

  // var check2;
  static Future<void> updateDishwareChecklist({
    String? name,
    String? quantity,
    String? color,
    String? size,
    String? productPosition,
    Map<String, dynamic>? tags,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);
    // print(documentReferencer.id);
    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "color": color,
      "size": size,
      "productPosition": productPosition,
      "tags": tags,
    };

    await documentReferencer.update(data).catchError((e) => Text(e));
  }

  static Future<void> updateDishwareChecklistImage({
    String? name,
    String? quantity,
    String? color,
    String? productPosition,
    String? imageUrl,
    String? size,
    Map<String, dynamic>? tags,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity.toString(),
      "color": color,
      "productPosition": productPosition,
      'imageUrl': imageUrl,
      'size': size,
      "tags": tags,
    };

    await documentReferencer.update(data);
  }

  static Stream<QuerySnapshot> getDishwareChecklist() {
    CollectionReference checklistItemCollection = _collectionReference;

    return checklistItemCollection.orderBy('name').snapshots();
  }

  // static Stream<DocumentSnapshot> showInventoryChecklist() {
  //   DocumentReference checklistItemCollection = _collectionReference.doc();

  //   return checklistItemCollection.snapshots();
  // }

  static Future<void> deleteChecklist({
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);
    await documentReferencer.delete();
    // .whenComplete(() => print('Dishware Deleted'))
    // .catchError((e) => print(e));
  }
}
