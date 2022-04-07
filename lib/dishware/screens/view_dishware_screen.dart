// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/sizedbox_widget.dart';
import 'package:warehouse/common_widgets/text_widget.dart';

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
  late int quantity;
  late String position;
  late String color;
  late String size;
  late String type;
  late String imageUrl;
  @override
  void initState() {
    if (widget.checkList != null) {
      name = widget.checkList!.name;
      quantity = int.parse(widget.checkList!.quantity);
      color = widget.checkList!.color;
      size = widget.checkList!.size;
      position = widget.checkList!.productPosition;
      imageUrl = widget.checkList!.imageUrl;
      type = widget.checkList!.type;
    }
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
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const LinearProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
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
                const SizedBox(height: 10.0),
                SizedBoxWidget(text: quantity.toString()),
                const SizedBox(height: 10.0),
                const TextWidget(text: 'Type'),
                const SizedBox(height: 10.0),
                SizedBoxWidget(text: type),
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
