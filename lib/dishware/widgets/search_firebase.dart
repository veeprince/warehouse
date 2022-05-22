import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/models/dishware_model.dart';
import 'package:warehouse/dishware/screens/add_dishware_screen.dart';
import 'package:warehouse/dishware/widgets/delete_widget.dart';
import 'package:warehouse/dishware/widgets/list_result.dart';
import 'package:warehouse/functions.dart';

class SearchFirebase extends StatefulWidget {
  final DishwareCheckList? checkList;

  final String? docId;
  const SearchFirebase({
    Key? key,
    this.checkList,
    this.docId,
  }) : super(key: key);
  @override
  _SearchFirebaseState createState() => _SearchFirebaseState();
}

class _SearchFirebaseState extends State<SearchFirebase> with DishFunctions {
  late String addName;

  late String addQuantity;
  late String addColor;
  late String addSize;
  late String codeDialog;
  String valueText = '';
  String locationText = '';
  dynamic tagGetter;
  String docID = '';

  TextEditingController textFieldController = TextEditingController();
  TextEditingController locationTextFieldController = TextEditingController();

  @override
  void initState() {
    //IMPLEMENT THIS................................
    // FirebaseFirestore.instance
    //     .collection("Dishware")
    //     .get()
    //     .then((QuerySnapshot querysnapshot) {
    //   for (var doc in querysnapshot.docs) {
    //     setState(() {
    //       produce.add(Dishware(
    //           name: doc['name'],
    //           quantity: doc["quantity"],
    //           color: doc['color'],
    //           size: doc['size'],
    //           productPosition: doc['productPosition'],
    //           imageUrl: doc['imageUrl'],
    //           tags: List.from(doc['tags'])));
    //     });
    //   }
    // });

    super.initState();
  }

  var productId = '';
  var name = '';
  static List<Dishware> produce = [];

  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          FirebaseFirestore.instance.collection("Dishware").get().then(
              (QuerySnapshot querysnapshot) {
            for (var doc in querysnapshot.docs) {
              if (produce.length == querysnapshot.docs.length) {
                return;
              } else if (querysnapshot.docs.length > produce.length ||
                  produce.length > querysnapshot.docs.length) {
                setState(() {
                  produce.add(Dishware(
                      name: doc['name'],
                      quantity: doc["quantity"],
                      color: doc['color'],
                      size: doc['size'],
                      productPosition: doc['productPosition'],
                      imageUrl: doc['imageUrl'],
                      tags: List.from(doc['tags'])));
                });
              }
            }
          }).then((value) => showSearch(
                context: context,
                delegate: SearchPage<Dishware>(
                  // itemEndsWith: true,
                  // itemStartsWith: true,
                  items: produce,

                  searchLabel: 'Search',
                  showItemsOnEmpty: false,
                  suggestion: const Center(
                    child:
                        Text('Search dishware by name, location or quantity'),
                  ),
                  failure: const Center(
                    child: Text('No dishware found :('),
                  ),
                  filter: (produce) => [
                    produce.name,
                    produce.quantity,
                    produce.color,
                    produce.size,
                    produce.imageUrl,
                    produce.tags.join(),
                  ],

                  builder: (product) => Stack(children: [
                    ListTile(
                      title: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(31, 0, 0, 0),
                            borderRadius: BorderRadius.circular(15)),
                        child: CachedNetworkImage(
                          fit: BoxFit.scaleDown,
                          imageUrl: product.imageUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  LinearProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      subtitle: Center(
                          child: Text(
                        product.quantity,
                        style: const TextStyle(fontSize: 20),
                      )),
                      onTap: () {
                        name = product.name;
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
                                    product.name,
                                    product.quantity,
                                    product.color,
                                    product.productPosition,
                                    product.imageUrl,
                                    product.size,
                                    product.tags,
                                  ),
                                  docID),
                              ListTile(
                                  leading: const Icon(Icons.update),
                                  title: const Text('Update'),
                                  onTap: () {
                                    dynamic dishwareChecklist =
                                        DishwareCheckList(
                                      product.name,
                                      product.quantity,
                                      product.color,
                                      product.productPosition,
                                      product.imageUrl,
                                      product.size,
                                      product.tags,
                                    );

                                    FirebaseFirestore.instance
                                        .collection("Dishware")
                                        .where("name", isEqualTo: product.name)
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
                                    }).whenComplete(() => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddDishwareScreen(
                                                        checkList:
                                                            dishwareChecklist,
                                                        docId: docID))));
                                  }),
                              DeleteWidget(product.name, productId),
                              const SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 61, 61, 61),
                            ),
                          ),
                          onPressed: () async {
                            _displayTextInputDialog(context)
                                .whenComplete(() async => {
                                      if (valueText.isNotEmpty &&
                                          locationText.isNotEmpty)
                                        {
                                          await sendEmail(valueText,
                                              product.imageUrl, locationText)
                                        }
                                    });
                          },
                          child: const Text(
                            "REQUEST",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ]),
                ),
                query: searchString,
              ));
          produce.clear();
        },
        icon: const Icon(Icons.search));
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
