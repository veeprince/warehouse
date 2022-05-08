import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:warehouse/common_widgets/textfield_widget.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/models/dishware_database_helper.dart';
import 'package:warehouse/dishware/models/types.dart';

class AddDishwareScreen extends StatefulWidget {
  final DishwareCheckList? checkList;
  final String? docId;

  const AddDishwareScreen({
    Key? key,
    this.checkList,
    this.docId,
  }) : super(key: key);
  @override
  AddDishwareScreenState createState() => AddDishwareScreenState();
}

class AddDishwareScreenState extends State<AddDishwareScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController productPositionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  late String imageUrl;
  late String type;
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  @override
  void initState() {
    if (widget.checkList != null) {
      nameController.text = widget.checkList!.name;
      quantityController.text = widget.checkList!.quantity;
      colorController.text = widget.checkList!.color;
      sizeController.text = widget.checkList!.size;
      productPositionController.text = widget.checkList!.productPosition;
      typeController.text = widget.checkList!.type;
    }
    super.initState();
  }

  // ignore: prefer_typing_uninitialized_variables
  var _image;
  var inProcess = true;
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
    return _image;
  }

  selectImageFromCamera() async {
    final picker = ImagePicker();
    setState(() {
      inProcess = true;
    });
    final imageFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024);
    if (imageFile != null) {
      _image = File(imageFile.path);
    }

    setState(() {
      inProcess = false;
    });
    return _image;
  }

  var downloadedURL = '';
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
        title: const Text("TAG Dishware list"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(shrinkWrap: true, children: [
          const SizedBox(height: 10.0),
          Material(
            elevation: 4.0,
            // shape: const RoundedRectangleBorder(),
            clipBehavior: Clip.none,
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
          const SizedBox(height: 10.0),
          Center(
            child: SelectFormField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              labelText: 'Dishware Type',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
              type: SelectFormFieldType.dropdown,
              items: types,
              onChanged: (val) {
                switch (val) {
                  case 'plateware':
                    typeController.text = 'Plateware';
                    break;
                  case 'metalware':
                    typeController.text = 'Metalware';
                    break;
                  case 'flatware':
                    typeController.text = 'Flatware';
                    break;
                  case 'glassware':
                    typeController.text = 'Glassware';
                    break;
                  default:
                }
              },
            ),
          ),
          const SizedBox(height: 10.0),
          const TextWidget(text: 'Dishware Name'),
          const SizedBox(height: 10.0),
          TextFieldWidget(
              enabled: true,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              text: "Enter the dishware name",
              controller: nameController),
          const SizedBox(height: 10.0),
          const TextWidget(text: "Dishware Quantity"),
          const SizedBox(
            height: 10,
          ),
          TextFieldWidget(
              enabled: true,
              text: "Enter the dishware quantity",
              controller: quantityController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number),
          const SizedBox(height: 10.0),
          const TextWidget(text: "Dishware Color"),
          const SizedBox(
            height: 10,
          ),
          TextFieldWidget(
              enabled: true,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              text: "Enter the color of the dishware",
              controller: colorController),
          const SizedBox(height: 10.0),
          const TextWidget(text: "Dishware Size"),
          const SizedBox(height: 10.0),
          TextFieldWidget(
              enabled: true,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              text: "Enter the size of the dishware",
              controller: sizeController),
          const SizedBox(height: 10.0),
          const TextWidget(text: 'Dishware Position'),
          const SizedBox(height: 10.0),
          TextFieldWidget(
              enabled: true,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
              text: "Enter the position of the dishware",
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
                {
                  if (widget.docId != null) {
                    if (_image == null) {
                      await DishwareDatabaseHelper.updateDishwareChecklist(
                        name: nameController.text,
                        quantity: quantityController.text,
                        color: colorController.text,
                        size: sizeController.text,
                        productPosition: productPositionController.text,
                        docId: widget.docId!,
                      );
                    } else {
                      FirebaseFirestore.instance
                          .collection("Dishware")
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
                            timer.cancel();
                            FirebaseStorage.instance
                                .refFromURL(imageId)
                                .delete();
                          });
                        } else {
                          if (imageId != null) {
                            // print(imageId);
                            FirebaseStorage.instance
                                .refFromURL(imageId)
                                .delete();
                          }
                        }
                      }).whenComplete(
                              () => uploadToFirestore().then((value) async {
                                    await DishwareDatabaseHelper
                                        .updateDishwareChecklistImage(
                                            name: nameController.text,
                                            quantity: quantityController.text,
                                            size: sizeController.text,
                                            color: colorController.text,
                                            productPosition:
                                                productPositionController.text,
                                            docId: widget.docId!,
                                            imageUrl: downloadedURL);
                                  }));
                    }
                  } else {
                    uploadToFirestore().then((value) async {
                      await DishwareDatabaseHelper.addDishwareCheckList(
                        name: nameController.text,
                        quantity: quantityController.text,
                        size: sizeController.text,
                        color: colorController.text,
                        productPosition: productPositionController.text,
                        type: typeController.text,
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
    colorController.dispose();
    sizeController.dispose();
    productPositionController.dispose();
    super.dispose();
  }
}
