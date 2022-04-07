import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryDatabaseHelper {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final CollectionReference _collectionReference =
      _firebaseFirestore.collection('Product');

  static Future<void> addInventoryCheckList({
    required String name,
    required String quantity,
    required String productLocation,
    required String productPosition,
    required String imageUrl,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "productLocation": productLocation,
      "productPosition": productPosition,
      "imageUrl": imageUrl
    };

    await documentReferencer.set(data);
  }

  static Future<void> updateInventoryChecklist({
    required String name,
    required String quantity,
    required String productLocation,
    required String productPosition,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "productLocation": productLocation,
      "productPosition": productPosition,
      // "imageUrl": imageUrl
    };

    await documentReferencer.update(data);
  }

  static Future<void> updateInventoryChecklistImage({
    required String name,
    required String quantity,
    required String productLocation,
    required String productPosition,
    String? imageUrl,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "productLocation": productLocation,
      "productPosition": productPosition,
      "imageUrl": imageUrl
    };

    await documentReferencer.update(data);
  }

  static Stream<QuerySnapshot> getInventoryChecklist() {
    CollectionReference checklistItemCollection = _collectionReference;

    return checklistItemCollection.orderBy('name').snapshots();
  }

  static Future<void> deleteChecklist({
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);
    await documentReferencer.delete();
  }
}
