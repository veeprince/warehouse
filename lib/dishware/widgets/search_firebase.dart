import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:warehouse/common_widgets/container_widget.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:warehouse/dishware/models/dishware_database_helper.dart';
import 'package:warehouse/dishware/models/dishware_model.dart';
import 'package:warehouse/dishware/screens/dishware_home.dart';
import 'package:warehouse/dishware/widgets/selec_form_field.dart';

class SearchFirebase extends StatefulWidget {
  const SearchFirebase({Key? key}) : super(key: key);

  @override
  SearchFirebaseState createState() => SearchFirebaseState();
}

class SearchFirebaseState extends State<SearchFirebase> {
  var productId = '';
  var name = '';
  bool isPressed = false;
  static List<Dishware> produce = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Dishware")
        .get()
        .then((QuerySnapshot querysnapshot) {
      for (var doc in querysnapshot.docs) {
        setState(() {
          produce.add(Dishware(
            name: doc['name'],
            quantity: doc["quantity"],
            color: doc['color'],
            size: doc['size'],
            productPosition: doc['productPosition'],
            imageUrl: doc['imageUrl'],
          ));
        });
      }
    });
    super.initState();
  }

  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: SearchPage<Dishware>(
              // itemEndsWith: true,
              // itemStartsWith: true,
              items: produce,

              searchLabel: 'Search',
              showItemsOnEmpty: false,
              suggestion: const Center(
                child: Text('Search dishware by name, location or quantity'),
              ),
              failure: const Center(
                child: Text('No dishware found :('),
              ),
              filter: (produce) => [
                produce.name,
                produce.quantity,
                produce.color,
                produce.size,
                produce.imageUrl
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
                          ListTile(
                              leading: const Icon(Icons.open_in_full),
                              title: const Text('View'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text("SearchPage"),
                                        ),
                                        body: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: 300.0,
                                                  height: 300.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .horizontal(),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              product.imageUrl),
                                                          fit: BoxFit.cover)),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text: 'Dishware Name'),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.name),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text: 'Dishware Quantity'),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.quantity
                                                        .toString()),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text: 'Dishware Color'),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.color),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text:
                                                        'Position In Warehouse'),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product
                                                        .productPosition),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              }),
                          const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: DishwareFormField()),
                          ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                              onTap: () {
                                // ignore: prefer_typing_uninitialized_variables
                                var imageId;
                                FirebaseFirestore.instance
                                    .collection("Dishware")
                                    .where("name", isEqualTo: product.name)
                                    .get()
                                    .then((value) {
                                  for (var element in value.docs) {
                                    FirebaseFirestore.instance
                                        .collection("Dishware")
                                        .doc(element.id);
                                    productId = element.id;
                                  }
                                }).whenComplete(() {
                                  FirebaseFirestore.instance
                                      .collection("Dishware")
                                      .doc(productId)
                                      .get()
                                      .then((value) {
                                    imageId = value.data()!["imageUrl"];
                                  });
                                }).whenComplete(() {
                                  if (imageId == null) {
                                    Timer.periodic(
                                        const Duration(microseconds: 1),
                                        (timer) {
                                      if (imageId != null) {
                                        timer.cancel();
                                        FirebaseStorage.instance
                                            .refFromURL(imageId)
                                            .delete();
                                        DishwareDatabaseHelper.deleteChecklist(
                                            docId: productId);
                                      }
                                    });
                                  }
                                }).whenComplete(() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DishwareHomePage(),
                                      ),
                                      (route) => route.isFirst);
                                });
                              }),
                          const SizedBox(
                            height: 20.0,
                          )
                        ],
                      ),
                    );
                  },
                ),
                // Align(
                //   alignment: const Alignment(0.5, 0.6),
                //   child: IconButton(
                //       icon: isPressed
                //           ? Icon(Icons.favorite_border)
                //           : Icon(
                //               Icons.favorite,
                //             ),
                //       onPressed: () {
                //         setState(() {
                //           // Here we changing the icon.
                //           isPressed = !isPressed;
                //         });
                //       }),
                // ),
              ]),
            ),
            query: searchString,
          );
        },
        icon: const Icon(Icons.search));
  }

  // Future<void> scanQRCode() async {
  //   final qrCode = await FlutterBarcodeScanner.scanBarcode(
  //       '#000000', 'Cancel', true, ScanMode.QR);
  //   if (!mounted) return;
  //   setState(() {
  //     this.qrCode = qrCode;
  //   });
  // }
}
