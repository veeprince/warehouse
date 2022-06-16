import 'package:flutter/material.dart';

import 'package:warehouse/dishware/models/dishware_checklist_model.dart';

import 'package:warehouse/dishware/widgets/search_page1.dart';

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
  @override
  void initState() {
    super.initState();
  }

  var productId = '';
  var name = '';

  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const CustomSearchPage(),
          ));
        },
        icon: const Icon(Icons.search));
  }
}
