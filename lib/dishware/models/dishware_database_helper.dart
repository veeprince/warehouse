import 'package:cloud_firestore/cloud_firestore.dart';

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
      required String type,
      required List<String> tags,
      required String size}) async {
    DocumentReference documentReferencer = _collectionReference.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "color": color,
      "productPosition": productPosition,
      "imageUrl": imageUrl,
      "type": type,
      "size": size,
      "tags": tags,
    };

    await documentReferencer.set(data);
    // .whenComplete(() => print("Dishware added"))
    // .catchError((e) => print(e));
  }

  // var check2;
  static Future<void> updateDishwareChecklist({
    String? name,
    String? quantity,
    String? color,
    String? size,
    String? productPosition,
    List<String>? tags,

    // String? type,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "quantity": quantity,
      "color": color,
      "size": size,
      "productPosition": productPosition,
      "tags": tags,
      // "type": type,
    };

    await documentReferencer.update(data);
    //       .whenComplete(() => print("Dishware Updated"))
    //       .catchError((e) => print(e));
  }

  static Future<void> updateDishwareChecklistImage({
    String? name,
    String? quantity,
    String? color,
    String? productPosition,
    String? imageUrl,
    String? size,
    List<String>? tags,

    // String? type,
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
