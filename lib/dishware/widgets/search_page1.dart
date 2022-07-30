import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController colorTextEditingController =
      TextEditingController();

  var searchString = '';
  var searchString2 = '';
  TextEditingController searchField = TextEditingController();
  TextEditingController searchField2 = TextEditingController();

  TextEditingController textFieldController = TextEditingController();
  TextEditingController locationTextFieldController = TextEditingController();
  String valueText = '';
  late String codeDialog;

  String locationText = '';
  List<String> finalMap = [];
  List<List<String>> check = [];
  var productId = '';
  var docID = "";
  final List<String> colorItems = [
    'Any',
    'Yellow',
    'Green',
    'Red',
    'Blue',
    'Brown',
    'Black',
    'Pink',
    'Orange',
    'White',
    'Gold',
    'Glass',
    'Wood'
  ];

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

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
    String element1 = "";
    String element2 = "";
    String element3 = "";
    var firestoreCol = FirebaseFirestore.instance.collection("Dishware");
    //check for a color other than any and searchField is not empty
    if (selectedValue != null &&
        selectedValue != "Any" &&
        searchField.text.isNotEmpty) {
      late Query<Map<String, dynamic>> color;
      late Query<Map<String, dynamic>> dishes;
      color =
          firestoreCol.where("color", isEqualTo: selectedValue!.toLowerCase());

      color.get().then((QuerySnapshot querysnapshot) {
        for (int i = 0; i < enteredKeyword.length; i++) {
          if (enteredKeyword.asMap().containsKey(0)) {
            element1 = enteredKeyword.elementAt(0);
          }
          if (enteredKeyword.asMap().containsKey(1)) {
            element2 = enteredKeyword.elementAt(1);
          }
          if (enteredKeyword.asMap().containsKey(2)) {
            element3 = enteredKeyword.elementAt(2);
          }

          // print(cities.runtimeType);

        }
        if (element1.isNotEmpty && element2.isEmpty && element3.isEmpty) {
          dishes = color.where("tags.$element1", isEqualTo: true);
        } else if (element1.isNotEmpty &&
            element2.isNotEmpty &&
            element3.isEmpty) {
          dishes = color
              .where("tags.$element1", isEqualTo: true)
              .where("tags.$element2", isEqualTo: true);
        } else if (element1.isNotEmpty &&
            element2.isNotEmpty &&
            element3.isNotEmpty) {
          dishes = color
              .where("tags.$element1", isEqualTo: true)
              .where("tags.$element2", isEqualTo: true)
              .where("tags.$element3", isEqualTo: true);
        }
        // dishes = color
        //     .where("tags.$element1", isEqualTo: true)
        //     .where("tags.$element2", isEqualTo: true)
        //     .where("tags.$element3", isEqualTo: true);
        dishes.get().then((QuerySnapshot querysnapshot) {
          // print(querysnapshot.docs.hashCode);
          // print(querysnapshot.docs);
          for (var doc in querysnapshot.docs) {
            foundUsers.add(doc.data() as Map<String, dynamic>);
            // foundUsers.contains(doc)
            // print(doc.data().runtimeType);
          }
        }).whenComplete(() => {
                  setState(() {
                    foundUsers;
                  })
                }

            // setState(() {
            // print(foundUsers);
            // foundUsers;
            //   if (searchField2.text.isEmpty) {
            //   return;
            // } else {
            //   print(foundUsers);
            // }
            // print(querysnapshot.docs);
            // for (var doc in querysnapshot.docs) {
            //   print(doc.data());
            // }
            // })

            );
      });
      //Check for colors with any with a word in the textfield
    } else if (selectedValue == "Any" && searchString.isNotEmpty) {
      late Query<Map<String, dynamic>> dishes;
      late Query<Map<String, dynamic>> color;
      color = firestoreCol.where("color");
      for (int i = 0; i < enteredKeyword.length; i++) {
        if (enteredKeyword.asMap().containsKey(0)) {
          element1 = enteredKeyword.elementAt(0);
        }
        if (enteredKeyword.asMap().containsKey(1)) {
          element2 = enteredKeyword.elementAt(1);
        }
        if (enteredKeyword.asMap().containsKey(2)) {
          element3 = enteredKeyword.elementAt(2);
        }

        // print(cities.runtimeType);

      }

      if (element1.isNotEmpty && element2.isEmpty && element3.isEmpty) {
        dishes = color.where("tags.$element1", isEqualTo: true);
      } else if (element1.isNotEmpty &&
          element2.isNotEmpty &&
          element3.isEmpty) {
        dishes = color
            .where("tags.$element1", isEqualTo: true)
            .where("tags.$element2", isEqualTo: true);
      } else if (element1.isNotEmpty &&
          element2.isNotEmpty &&
          element3.isNotEmpty) {
        dishes = color
            .where("tags.$element1", isEqualTo: true)
            .where("tags.$element2", isEqualTo: true)
            .where("tags.$element3", isEqualTo: true);
      }

      dishes.get().then((QuerySnapshot querysnapshot) {
        // print(querysnapshot.docs);
        for (var doc in querysnapshot.docs) {
          // print(doc);
          foundUsers.add(doc.data() as Map<String, dynamic>);
        }
      }).whenComplete(() => setState(() {
            foundUsers;
          }));
      //return all dishware in collection
    } else if (selectedValue == "Any" && searchString.isEmpty) {
      late Query<Map<String, dynamic>> color;

      color = firestoreCol.where("color");
      color.get().then((QuerySnapshot querysnapshot) {
        // print(querysnapshot.docs);
        for (var doc in querysnapshot.docs) {
          foundUsers.add(doc.data() as Map<String, dynamic>);
        }
      }).whenComplete(() => setState(() {
            foundUsers;
          }));
      //return where color is selected but no input data in searchfield
    } else if (selectedValue!.isNotEmpty && searchString.isEmpty) {
      late Query<Map<String, dynamic>> color;
      color =
          firestoreCol.where("color", isEqualTo: selectedValue!.toLowerCase());
      color.get().then((QuerySnapshot querysnapshot) {
        // print(querysnapshot.docs);
        for (var doc in querysnapshot.docs) {
          foundUsers.add(doc.data() as Map<String, dynamic>);
        }
      }).whenComplete(() => setState(() {
            foundUsers;
          }));
    }
    //require a color
    else {
      foundUsers = [];

      ScaffoldMessenger.of(context).showSnackBar(snackbarRenderer("Oh snap",
          "Please select a color or enter a search word", ContentType.failure));
    }

    // return;
    // for (var element in enteredKeyword) {
    //   // print(element);
    //   cities = firestoreCol.where("tags.$element", isEqualTo: true);
    //   // print(cities.runtimeType);
    // }
    foundUsers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 120,
        title: Center(
          child: Container(
            // height: 49,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 42, 42, 42),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 3.0, right: 20),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: searchField,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.search),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: IconButton(
                          splashColor: Colors.grey,
                          splashRadius: 30,
                          onPressed: () {
                            searchString = searchField.text;

                            _runFilter(searchString.split(" "));
                            foundUsers = [];
                          },
                          icon: const Icon(Icons.search_sharp)),
                    ),
                    prefixIcon: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 75,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField2(
                                // customItemsHeight: 9,

                                customButton: renderWidget(selectedValue == null
                                    ? "Color"
                                    : selectedValue!),
                                decoration: const InputDecoration(
                                  //Add isDense true and zero Padding.
                                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                  isDense: false,
                                  contentPadding: EdgeInsets.all(8),
                                ),
                                isExpanded: true,

                                items: colorItems
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a color.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                  selectedValue = value.toString();
                                  // print(value);
                                  //Do something when changing the item if you want.
                                },
                                // onSaved: (value) {
                                //   print(value);
                                //   selectedValue = value.toString();
                                // },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: ' Search...',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // const SizedBox(
          //   height: 10,
          // ),

          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: foundUsers.isNotEmpty
                ? ListView.builder(
                    itemCount: foundUsers.length,
                    itemBuilder: (context, index) => Stack(children: [
                      ListTile(
                        title: Stack(children: [
                          Center(
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
                                var image = foundUsers[index]["imageUrl"];
                                _displayTextInputDialog(context)
                                    .whenComplete(() async => {
                                          if (valueText.isNotEmpty &&
                                              locationText.isNotEmpty)
                                            {
                                              await sendEmail(valueText, image,
                                                  locationText)
                                            }
                                        })
                                    .whenComplete(() => {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbarRenderer(
                                                  "Hurray",
                                                  "Facilities have been notified of your request",
                                                  ContentType.success))
                                        });
                              },
                              child: const Text(
                                "REQUEST",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        onTap: () {
                          name = foundUsers[index]["imageUrl"];
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
                                      foundUsers[index]["quantity"],
                                      foundUsers[index]["imageUrl"],
                                      foundUsers[index]["color"],
                                      foundUsers[index]["tags"],
                                      foundUsers[index]["locations"],
                                    ),
                                    docID),
                                ListTile(
                                    leading: const Icon(Icons.update),
                                    title: const Text('Update'),
                                    onTap: () {
                                      dynamic dishwareChecklist =
                                          DishwareCheckList(
                                        foundUsers[index]["quantity"],
                                        foundUsers[index]["imageUrl"],
                                        foundUsers[index]["color"],
                                        foundUsers[index]["tags"],
                                        foundUsers[index]["locations"],
                                      );

                                      FirebaseFirestore.instance
                                          .collection("Dishware")
                                          .where(
                                            "imageUrl",
                                            isEqualTo: foundUsers[index]
                                                ["imageUrl"],
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
                                    }),
                                DeleteWidget(
                                    foundUsers[index]["imageUrl"], productId),
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
                      'No plateware found',
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
                  if (valueText.isEmpty || locationText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(snackbarRenderer(
                        "Ooops",
                        "Please enter a quantity or a delivery location",
                        ContentType.warning));
                  } else {
                    setState(() {
                      codeDialog = valueText;
                      Navigator.pop(context);
                      textFieldController.clear();
                      locationTextFieldController.clear();
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  renderWidget(String condition) {
    return Text(
      condition,
      style: GoogleFonts.aBeeZee(
        color: const Color.fromARGB(255, 165, 165, 165),
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

snackbarRenderer(String title, String message, ContentType contentType) {
  return SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: contentType,
    ),
  );
}
