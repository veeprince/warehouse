import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:warehouse/common_widgets/container_widget.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:warehouse/inventory/models/inventory_database_helper.dart';
import 'package:warehouse/inventory/models/product_model.dart';
import 'package:warehouse/inventory/screens/inventory_home.dart';
import 'package:warehouse/inventory/widgets/inventory_form.dart';

class SearchInventory extends StatefulWidget {
  const SearchInventory({Key? key}) : super(key: key);

  @override
  SearchInventoryState createState() => SearchInventoryState();
}

class SearchInventoryState extends State<SearchInventory> {
  // ignore: prefer_typing_uninitialized_variables
  var name;
  // ignore: prefer_typing_uninitialized_variables
  var productId;
  // ignore: prefer_typing_uninitialized_variables
  var imageId;
  static List<Product> produce = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Product")
        .get()
        .then((QuerySnapshot querysnapshot) {
      for (var doc in querysnapshot.docs) {
        setState(() {
          produce.add(Product(
              name: doc['name'],
              quantity: doc["quantity"],
              productLocation: doc['productLocation'],
              productPosition: doc['productPosition'],
              imageUrl: doc['imageUrl']));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: SearchPage<Product>(
              showItemsOnEmpty: false,
              items: produce,
              searchLabel: 'Search warehouse',
              suggestion: const Center(
                child: Text('Search products by name, location or quantity'),
              ),
              failure: const Center(
                child: Text('No product found :('),
              ),
              filter: (produce) => [
                produce.name,
                produce.quantity,
                produce.productLocation,
                produce.productLocation,
                produce.imageUrl
              ],
              builder: (product) => ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.quantity),
                  trailing: Text(product.productLocation),
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
                                                    text: 'Product Name'),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.name),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text: 'Product Quantity'),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.quantity),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text: 'Location'),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product
                                                        .productLocation),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text:
                                                        'Position in Warehouse'),
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
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: InventoryForm()),
                          ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("Product")
                                    .where("name", isEqualTo: product.name)
                                    .get()
                                    .then((value) {
                                  for (var element in value.docs) {
                                    FirebaseFirestore.instance
                                        .collection("Product")
                                        .doc(element.id);
                                    productId = element.id;
                                  }
                                }).whenComplete(() {
                                  // print(productId);

                                  FirebaseFirestore.instance
                                      .collection("Product")
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
                                        // print(imageId);
                                        FirebaseStorage.instance
                                            .refFromURL(imageId)
                                            .delete();
                                        InventoryDatabaseHelper.deleteChecklist(
                                            docId: productId);
                                      }
                                    });
                                  }
                                }).whenComplete(() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const InventoryHomePage(),
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
                  }),
            ),
          );
        },
        icon: const Icon(Icons.search));
  }
}
