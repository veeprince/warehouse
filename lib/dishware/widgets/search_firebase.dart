import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:search_page/search_page.dart';
import 'package:warehouse/blocs/google_auth_api.dart';
import 'package:warehouse/common_widgets/container_widget.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:warehouse/dishware/models/dishware_database_helper.dart';
import 'package:warehouse/dishware/models/dishware_model.dart';
import 'package:warehouse/dishware/screens/dishware_home.dart';
import 'package:warehouse/dishware/widgets/selec_form_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchFirebase extends StatefulWidget {
  const SearchFirebase({Key? key}) : super(key: key);

  @override
  SearchFirebaseState createState() => SearchFirebaseState();
}

class SearchFirebaseState extends State<SearchFirebase> {
  late String codeDialog;
  late String valueText;
  late String locationText;
  TextEditingController textFieldController = TextEditingController();
  TextEditingController locationTextFieldController = TextEditingController();
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
                // color: Colors.red,
                // textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                // color: Colors.green,
                // textColor: Colors.white,
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

  SnackBar showSnackBar(String text) {
    return SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.green,
    );
  }

  var productId = '';
  var name = '';
  bool isFavourite = true;
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
              tags: List.from(doc['tags'])));
        });
      }
    });
    super.initState();
  }

  Future sendEmail(amount, url, location) async {
    // GoogleAuthApi.signOut();
    // return;
    final user = await GoogleAuthApi.signIn();
    // print(user);
    if (user == null) return;

    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken!;
    GoogleAuthApi.signOut();

    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = Address(email, dotenv.env['NAME'])
      ..recipients = [dotenv.env['EMAIL']]
      ..subject = "Dishware Request"
      ..html =
          '<p>${user.displayName} would like $amount of this dishware delivered to $location.</p><img src="$url" width="500" height="600">'
      ..text = "$amount amount";

    try {
      await send(message, smtpServer);
      showSnackBar('Sent email successfully');
    } on MailerException catch (e) {
      // ignore: avoid_print
      print(e);
    }
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
                                                const Divider(
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                    text: 'Dishware Tags'),
                                                const SizedBox(height: 20.0),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: product.tags
                                                        .map((e) => Text(
                                                              "$e ",
                                                              style: GoogleFonts
                                                                  .aBeeZee(
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    252,
                                                                    252),
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const TextWidget(
                                                    text: 'Dishware Quantity'),
                                                const SizedBox(height: 5.0),
                                                ContainerWidget(
                                                    text: product.quantity
                                                        .toString()),
                                                const Divider(
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const TextWidget(
                                                    text: 'Dishware Color'),
                                                const SizedBox(height: 5.0),
                                                ContainerWidget(
                                                    text: product.color),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                ),
                                                const TextWidget(
                                                    text:
                                                        'Position In Warehouse'),
                                                const SizedBox(height: 5.0),
                                                ContainerWidget(
                                                    text: product
                                                        .productPosition),
                                                const Divider(
                                                  color: Colors.grey,
                                                ),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 61, 61, 61),
                        ),
                      ),
                      onPressed: () async {
                        _displayTextInputDialog(context).whenComplete(
                            () async => await sendEmail(
                                valueText, product.imageUrl, locationText));
                      },
                      child: const Text(
                        "REQUEST",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                // Align(
                //   alignment: const Alignment(0.8, 0.9),
                //   child: FavoriteButton(
                //     iconSize: 45,
                //     isFavorite: false,
                //     iconDisabledColor: Colors.white,
                //     valueChanged: (_isFavorite) {
                //       print('Is Favorite : $_isFavorite');
                //     },
                //   ),
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
