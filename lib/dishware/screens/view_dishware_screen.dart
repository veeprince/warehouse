// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warehouse/common_widgets/sizedbox_widget.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import 'package:collection/collection.dart';
import '../models/dishware_checklist_model.dart';

class ViewDishwareScreen extends StatefulWidget {
  final DishwareCheckList? checkList;
  final String? docId;
  const ViewDishwareScreen({
    Key? key,
    this.checkList,
    this.docId,
  }) : super(key: key);

  @override
  _ViewDishwareScreenState createState() => _ViewDishwareScreenState();
}

var uuid;

class _ViewDishwareScreenState extends State<ViewDishwareScreen> {
  late String name;
  late String quantity;
  late String position;
  late String color;
  late String size;
  late String imageUrl;
  late Map<String, dynamic> tags;
  List<Widget> textWidgetList = <Widget>[]; // Here we defined a list of widget!

  @override
  void initState() {
    if (widget.checkList != null) {
      name = widget.checkList!.name;
      quantity = widget.checkList!.quantity;
      color = widget.checkList!.color;
      size = widget.checkList!.size;
      position = widget.checkList!.productPosition;
      imageUrl = widget.checkList!.imageUrl;
      tags = widget.checkList!.tags;
      print(tags);
    }
    // // for (int i = 0; i < tags.length; i++) {
    // for (var v in tags.keys) {
    //   print(v);

    //   //below is the solution
    //   // v.().forEach((i, value) {
    //   //   print('index=$i, value=$value');
    //   // });
    // }
    textWidgetList.add(
      Text(
        "${tags.keys.join(", ")}  ",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: GoogleFonts.aBeeZee(
          color: const Color.fromARGB(255, 255, 252, 252),
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    // }
    super.initState();
  }

  var img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TAG"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          // shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300.0,
              height: 300.0,
              child: Container(
                width: double.infinity,
                height: 280,
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: widget.checkList!.imageUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      LinearProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 10.0),
                const TextWidget(text: 'Dishware Name'),
                const SizedBox(height: 10.0),
                SizedBoxWidget(text: name),
                const SizedBox(height: 10.0),
                const TextWidget(text: 'Quantity'),
                SizedBoxWidget(text: quantity),
                const SizedBox(height: 10.0),
                const TextWidget(text: 'Tags'),
                const SizedBox(height: 10.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: textWidgetList,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 10.0),
                const TextWidget(text: 'Color'),
                const SizedBox(height: 10.0),
                SizedBoxWidget(text: color),
                const SizedBox(height: 10.0),
                const TextWidget(text: 'Size'),
                const SizedBox(height: 10.0),
                SizedBoxWidget(text: size),
                const SizedBox(height: 10.0),
                const TextWidget(text: 'Position'),
                const SizedBox(height: 10.0),
                SizedBoxWidget(text: position),
                const SizedBox(height: 10.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
