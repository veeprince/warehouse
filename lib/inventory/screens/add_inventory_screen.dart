import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:warehouse/common_widgets/textfield_widget.dart';
import 'package:warehouse/inventory/models/inventory_checklist_model.dart';
import 'package:warehouse/inventory/models/inventory_database_helper.dart';

class AddInventoryScreen extends StatefulWidget {
  final InventoryCheckList? checkList;
  final String? docId;

  const AddInventoryScreen({
    Key? key,
    this.checkList,
    this.docId,
  }) : super(key: key);
  @override
  AddInventoryScreenState createState() => AddInventoryScreenState();
}

class AddInventoryScreenState extends State<AddInventoryScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController productPositionController = TextEditingController();

  @override
  void initState() {
    if (widget.checkList != null) {
      nameController.text = widget.checkList!.name;
      quantityController.text = widget.checkList!.quantity;
      locationController.text = widget.checkList!.productLocation;
      productPositionController.text = widget.checkList!.productPosition;
    }
    super.initState();
  }

  // ignore: prefer_typing_uninitialized_variables
  var _image;
  var inProcess = true;
  var downloadedURL = '';
  selectImageFromGallery() async {
    final picker = ImagePicker();
    setState(() {
      inProcess = true;
    });
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _image = File(imageFile.path);
    }

    setState(() {
      inProcess = false;
    });
  }

  selectImageFromCamera() async {
    final picker = ImagePicker();
    setState(() {
      inProcess = true;
    });
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      _image = File(imageFile.path);
    }

    setState(() {
      inProcess = false;
    });
  }

  Future<String> uploadFile(File image) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child("post_$postId.jpg");
    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirestore() async {
    String url = await uploadFile(_image);
    downloadedURL = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TAG Inventory list"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(shrinkWrap: true, children: [
          const SizedBox(height: 10.0),
          Material(
            elevation: 4.0,
            shape: const RoundedRectangleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.grey,
            child: Ink.image(
              image: _image == null
                  ? const AssetImage('assets/images/568165.png')
                  : FileImage(_image) as ImageProvider,
              fit: BoxFit.cover,
              child: Container(
                width: 100,
                height: 300,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      enableDrag: true,
                      isDismissible: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              leading: const Icon(Icons.camera_alt_sharp),
                              title: const Text('Camera'),
                              onTap: () {
                                selectImageFromCamera();
                                Navigator.of(context).pop();
                              }),
                          ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Gallery'),
                              onTap: () {
                                selectImageFromGallery();
                                Navigator.of(context).pop();
                              }),
                          const SizedBox(
                            height: 20.0,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          const TextWidget(text: 'Product Name'),
          const SizedBox(height: 10.0),
          TextFieldWidget(
              enabled: true,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.name,
              text: "Enter the product name",
              controller: nameController),
          const SizedBox(height: 10.0),
          const TextWidget(text: 'Product Quantity'),
          const SizedBox(height: 10.0),
          TextFieldWidget(
              enabled: true,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number,
              text: "Enter the product quantity",
              controller: quantityController),
          const SizedBox(height: 10.0),
          const TextWidget(text: 'Product Location'),
          const SizedBox(height: 10.0),
          TextFieldWidget(
              enabled: true,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.text,
              text: "Enter the location of the product",
              controller: locationController),
          const SizedBox(height: 10.0),
          const TextWidget(text: 'Product Position'),
          const SizedBox(height: 10.0),
          TextFieldWidget(
              enabled: true,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              text: "Enter the position of the product",
              controller: productPositionController),
          const SizedBox(height: 10.0),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                if (nameController.text.trim().isNotEmpty &&
                    quantityController.text.trim().isNotEmpty &&
                    locationController.text.trim().isNotEmpty &&
                    productPositionController.text.trim().isNotEmpty) {
                  if (widget.docId != null) {
                    if (_image == null) {
                      await InventoryDatabaseHelper.updateInventoryChecklist(
                        name: nameController.text,
                        quantity: quantityController.text,
                        productLocation: locationController.text,
                        productPosition: productPositionController.text,
                        docId: widget.docId!,
                      );
                    } else {
                      FirebaseFirestore.instance
                          .collection("Product")
                          .doc(widget.docId.toString())
                          .get()
                          .then((value) {
                        // var id = value.data()!["imageUrl"];
                        // print(value.data()!["imageUrl"]);
                        imageId = value.data()!["imageUrl"];
                      }).whenComplete(() {
                        if (imageId == null) {
                          // print('Image is null');
                          Timer.periodic(const Duration(microseconds: 1),
                              (timer) {
                            if (imageId != null) {
                              timer.cancel();
                              FirebaseStorage.instance
                                  .refFromURL(imageId)
                                  .delete();
                            }
                          });
                        } else if (imageId != null) {
                          // print(imageId);
                          FirebaseStorage.instance.refFromURL(imageId).delete();
                        }
                      }).whenComplete(
                              () => uploadToFirestore().then((value) async {
                                    await InventoryDatabaseHelper
                                        .updateInventoryChecklistImage(
                                            name: nameController.text,
                                            quantity: quantityController.text,
                                            productLocation:
                                                locationController.text,
                                            productPosition:
                                                productPositionController.text,
                                            docId: widget.docId!,
                                            imageUrl: downloadedURL);
                                  }));
                    }
                  } else {
                    uploadToFirestore().then((value) async {
                      await InventoryDatabaseHelper.addInventoryCheckList(
                        name: nameController.text,
                        quantity: quantityController.text,
                        productLocation: locationController.text,
                        productPosition: productPositionController.text,
                        imageUrl: downloadedURL,
                      );
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  widget.docId != null ? 'UPDATE' : 'ADD',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    locationController.dispose();
    productPositionController.dispose();

    super.dispose();
  }
}
