import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:warehouse/common_widgets/textfield_widget.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/models/dishware_database_helper.dart';
import 'package:warehouse/common_widgets/tags.dart';

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

  TextEditingController quantityController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextfieldTagsController textFieldController = TextfieldTagsController();
  TextfieldTagsController locationFieldController = TextfieldTagsController();
  late String imageUrl;
  late Map<String, dynamic> tags;
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  List<String> locationGetter = [];
  List<String> tagGetter = [];
  late String docId;
  @override
  void initState() {
    if (widget.checkList != null) {
      quantityController.text = widget.checkList!.quantity;
      colorController.text = widget.checkList!.color;
      locationGetter
          .addAll(widget.checkList!.locations.keys.join(" ").split(" "));
      tagGetter.addAll(widget.checkList!.tags.keys.join(" ").split(" "));
      docId = widget.docId!;
      // print(tagGetter);
      // print(controller.getTags);
      // for (int i = 0; i < widget.checkList!.tags.length; i++) {
      //   tags.add()
      // }
    }
    // controller = TextfieldTagsController();

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
        title: const Text("Add TAG Plateware"),
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

          const TextWidget(text: 'Plateware Tags'),
          const SizedBox(height: 5.0),

          TagWidget(
            tagGetter: tagGetter,
            textFieldController: textFieldController,
          ),
          const SizedBox(height: 5.0),
          const TextWidget(text: 'Enter the locations'),
          const SizedBox(height: 5.0),

          TagWidget(
            tagGetter: locationGetter,
            textFieldController: locationFieldController,
          ),
          // TextFieldTags(
          //   initialTags: tagGetter,
          //   textfieldTagsController: textFieldController,
          //   textSeparators: const [' ', ','],
          //   letterCase: LetterCase.normal,
          //   inputfieldBuilder:
          //       (context, tec, fn, error, onChanged, onSubmitted) {
          //     return ((context, sc, tags, onTagDelete) {
          //       return Padding(
          //         padding: const EdgeInsets.all(2.0),
          //         child: TextField(
          //           controller: tec,
          //           focusNode: fn,
          //           decoration: InputDecoration(
          //             isDense: true,
          //             border: const OutlineInputBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //               borderSide: BorderSide(
          //                 color: Color.fromARGB(255, 0, 0, 0),
          //                 width: 3.0,
          //               ),
          //             ),
          //             focusedBorder: const OutlineInputBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //               borderSide: BorderSide(
          //                 color: Color.fromARGB(255, 123, 123, 123),
          //                 width: 1.0,
          //               ),
          //             ),
          //             helperText: 'Seperated by comma',
          //             helperStyle: const TextStyle(
          //               color: Color.fromARGB(255, 179, 179, 179),
          //             ),
          //             hintText:
          //                 textFieldController.hasTags ? '' : "Enter the dishware tags",
          //             errorText: error,
          //             prefixIconConstraints:
          //                 BoxConstraints(maxWidth: _distanceToField * 0.74),
          //             prefixIcon: tags.isNotEmpty
          //                 ? SingleChildScrollView(
          //                     controller: sc,
          //                     scrollDirection: Axis.horizontal,
          //                     child: Row(
          //                         children: tags.map((String tag) {
          //                       return Container(
          //                         decoration: const BoxDecoration(
          //                           borderRadius: BorderRadius.all(
          //                             Radius.circular(40.0),
          //                           ),
          //                           color: Color.fromARGB(255, 163, 163, 164),
          //                         ),
          //                         margin: const EdgeInsets.symmetric(
          //                             horizontal: 5.0),
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 10.0, vertical: 5.0),
          //                         child: Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             InkWell(
          //                               child: Text(
          //                                 '#$tag',
          //                                 style: const TextStyle(
          //                                     color: Colors.white),
          //                               ),
          //                               onTap: () {
          //                                 // ignore: avoid_print
          //                                 print("$tag selected");
          //                               },
          //                             ),
          //                             const SizedBox(width: 4.0),
          //                             InkWell(
          //                               child: const Icon(
          //                                 Icons.cancel,
          //                                 size: 14.0,
          //                                 color: Color.fromARGB(
          //                                     255, 233, 233, 233),
          //                               ),
          //                               onTap: () {
          //                                 onTagDelete(tag);
          //                               },
          //                             )
          //                           ],
          //                         ),
          //                       );
          //                     }).toList()),
          //                   )
          //                 : null,
          //           ),
          //           onChanged: onChanged,
          //           onSubmitted: onSubmitted,
          //         ),
          //       );
          //     });
          //   },
          // ),
          // ElevatedButton(
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all<Color>(
          //       const Color.fromARGB(255, 152, 152, 152),
          //     ),
          //   ),
          //   onPressed: () {
          //     textFieldController.clearTags();
          //   },
          //   child: const Text('CLEAR TAGS'),
          // ),
          const SizedBox(height: 5.0),
          const TextWidget(text: "Plateware Quantity"),
          const SizedBox(
            height: 5,
          ),
          TextFieldWidget(
              enabled: true,
              text: "Enter the plateware quantity",
              controller: quantityController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number),
          const SizedBox(height: 5.0),
          const TextWidget(text: "Plateware Color"),
          const SizedBox(
            height: 5,
          ),
          TextFieldWidget(
              enabled: true,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              text: "Enter the color of the plateware",
              controller: colorController),
          const SizedBox(height: 5.0),
          // const TextWidget(text: "Dishware Size"),
          // const SizedBox(height: 10.0),
          // TextFieldWidget(
          //     enabled: true,
          //     textInputType: TextInputType.text,
          //     textInputAction: TextInputAction.next,
          //     text: "Enter the size of the dishware",
          //     controller: sizeController),
          // const SizedBox(height: 10.0),
          // const TextWidget(text: 'Dishware Position'),
          // const SizedBox(height: 10.0),
          // TextFieldWidget(
          //     enabled: true,
          //     textInputType: TextInputType.text,
          //     textInputAction: TextInputAction.done,
          //     text: "Enter the position of the dishware",
          //     controller: productPositionController),
          // const SizedBox(height: 10.0),
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
                        quantity: quantityController.text,
                        color: colorController.text,
                        locations: {
                          for (var item in locationFieldController.getTags!)
                            item: true
                        },
                        tags: {
                          for (var item in textFieldController.getTags!)
                            item: true
                        },
                        docId: docId,
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
                      }).whenComplete(() =>
                              uploadToFirestore().then((value) async {
                                await DishwareDatabaseHelper
                                    .updateDishwareChecklistImage(
                                        quantity:
                                            quantityController.text.trim(),
                                        color: colorController.text.trim(),
                                        locations: {
                                          for (var item
                                              in locationFieldController
                                                  .getTags!)
                                            item: true
                                        },
                                        tags: {
                                          for (var item
                                              in textFieldController.getTags!)
                                            item: true
                                        },
                                        docId: docId,
                                        imageUrl: downloadedURL);
                              }));
                    }
                  } else {
                    uploadToFirestore().then((value) async {
                      await DishwareDatabaseHelper.addDishwareCheckList(
                        tags: {
                          for (var item in textFieldController.getTags!)
                            item: true
                        },
                        locations: {
                          for (var item in locationFieldController.getTags!)
                            item: true
                        },
                        quantity: quantityController.text.trim(),
                        color: colorController.text.trim(),
                        imageUrl: downloadedURL,
                      );
                    });
                  }

                  Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
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
    quantityController.dispose();
    colorController.dispose();
    locationFieldController.dispose();
    textFieldController.dispose();
    super.dispose();
  }
}
