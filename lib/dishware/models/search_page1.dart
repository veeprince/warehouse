// main.dart
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/screens/add_dishware_screen.dart';
import 'package:warehouse/dishware/widgets/delete_widget.dart';
import 'package:warehouse/dishware/widgets/list_result.dart';
import 'package:warehouse/functions.dart';

class CustomSearchPage extends StatefulWidget {
  const CustomSearchPage({Key? key}) : super(key: key);

  @override
  _CustomSearchPageState createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends State<CustomSearchPage>
    with DishFunctions {
  var searchString = '';
  TextEditingController searchField = TextEditingController();

  TextEditingController textFieldController = TextEditingController();
  TextEditingController locationTextFieldController = TextEditingController();
  String valueText = '';
  late String codeDialog;

  String locationText = '';
  List<String> finalMap = [];
  List<List<String>> check = [];
  var productId = '';
  var docID = "";

  final List<Map<String, dynamic>> _allUsers = [];
  // This list holds the data for the list view
  List<Map<String, dynamic>> foundUsers = [];
  List<Map<String, dynamic>> results = [];
  List<String> result = [];
  var name = '';
  @override
  initState() {
    FirebaseFirestore.instance
        .collection("Dishware")
        .get()
        .then((QuerySnapshot querysnapshot) {
      for (var doc in querysnapshot.docs) {
        _allUsers.add(doc.data() as Map<String, dynamic>);
      }
    });

    super.initState();
  }

  void _runFilter(List<String> enteredKeyword) {
    // print(_allUsers);
    late Query<Map<String, dynamic>> cities;
    var firestoreCol = FirebaseFirestore.instance.collection("Dishware");

    for (var element in enteredKeyword) {
      // print(element);
      cities = firestoreCol.where("tags.$element", isEqualTo: true);
      // print(cities.runtimeType);
    }

    cities.get().then((QuerySnapshot querysnapshot) {
      // print(querysnapshot.docs);
      for (var doc in querysnapshot.docs) {
        // print(doc);
        foundUsers.add(doc.data() as Map<String, dynamic>);
      }
    }).whenComplete(() => setState(() {
          foundUsers;
        }));
    foundUsers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Center(
          child: Container(
            // width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 42, 42, 42),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: searchField,
                  decoration: InputDecoration(

                      // prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          searchString = searchField.text;
                          _runFilter(searchString.split(" "));
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
        ),
      )),
      body: Column(
        children: [
          // const SizedBox(
          //   height: 10,
          // ),

          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: foundUsers.isNotEmpty
                ? ListView.builder(
                    itemCount: foundUsers.length,
                    itemBuilder: (context, index) => Stack(children: [
                      ListTile(
                        title: Stack(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 370,
                              height: 300,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(31, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(15)),
                              child: CachedNetworkImage(
                                fit: BoxFit.scaleDown,
                                imageUrl: foundUsers[index]["imageUrl"],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        LinearProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Center(
                              child: Text(
                            foundUsers[index]["quantity"],
                            style: const TextStyle(fontSize: 20),
                          )),
                        ]),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // maximumSize: const Size(10, 10),
                                primary: const Color.fromARGB(255, 61, 61, 61),
                              ),
                              onPressed: () async {
                                _displayTextInputDialog(context)
                                    .whenComplete(() async => {
                                          if (valueText.isNotEmpty &&
                                              locationText.isNotEmpty)
                                            {
                                              await sendEmail(
                                                      valueText,
                                                      foundUsers[index]
                                                          ["imageUrl"],
                                                      locationText)
                                                  .whenComplete(
                                                () => Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AlertDialog(
                                                        buttonPadding:
                                                            EdgeInsets.zero,
                                                        backgroundColor:
                                                            Colors.grey[900],
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: const Text(
                                                            "Email sent")),
                                                  ],
                                                ),
                                              )
                                            }
                                        });
                              },
                              child: const Text(
                                "REQUEST",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        onTap: () {
                          name = foundUsers[index]["name"];
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
                                SearchPageList(
                                    DishwareCheckList(
                                      foundUsers[index]["name"],
                                      foundUsers[index]["quantity"],
                                      foundUsers[index]["color"],
                                      foundUsers[index]["productPosition"],
                                      foundUsers[index]["imageUrl"],
                                      foundUsers[index]["size"],
                                      foundUsers[index]["tags"],
                                    ),
                                    docID),
                                ListTile(
                                    leading: const Icon(Icons.update),
                                    title: const Text('Update'),
                                    onTap: () {
                                      dynamic dishwareChecklist =
                                          DishwareCheckList(
                                        foundUsers[index]["name"],
                                        foundUsers[index]["quantity"],
                                        foundUsers[index]["color"],
                                        foundUsers[index]["productPosition"],
                                        foundUsers[index]["imageUrl"],
                                        foundUsers[index]["size"],
                                        foundUsers[index]["tags"],
                                      );

                                      FirebaseFirestore.instance
                                          .collection("Dishware")
                                          .where(
                                            "name",
                                            isEqualTo: foundUsers[index]
                                                ["name"],
                                          )
                                          .get()
                                          .then((value) {
                                        for (var element in value.docs) {
                                          setState(() {
                                            docID = element.id;
                                          });
                                          FirebaseFirestore.instance
                                              .collection("Dishware")
                                              .doc(element.id);
                                        }
                                      }).whenComplete(() => {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  settings: const RouteSettings(
                                                      name:
                                                          "/AddDishwareScreen"),
                                                  builder: (context) =>
                                                      AddDishwareScreen(
                                                          checkList:
                                                              dishwareChecklist,
                                                          docId: docID),
                                                ))
                                              });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             AddDishwareScreen(
                                      //                 checkList:
                                      //                     dishwareChecklist,
                                      //                 docId: docID)))
                                    }),
                                DeleteWidget(
                                    foundUsers[index]["name"], productId),
                                const SizedBox(
                                  height: 20.0,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ]),
                  )
                : const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
          )
        ],
      ),
    );
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
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                    textFieldController.clear();
                    locationTextFieldController.clear();
                  });
                },
              ),
            ],
          );
        });
  }
}
