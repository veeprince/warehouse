import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/sizedbox_widget.dart';

import 'package:warehouse/common_widgets/text_widget.dart';

import '../models/inventory_checklist_model.dart';

class ViewInventoryScreen extends StatefulWidget {
  final InventoryCheckList? checkList;
  final String? docId;
  const ViewInventoryScreen({
    Key? key,
    this.checkList,
    this.docId,
  }) : super(key: key);

  @override
  _ViewInventoryScreenState createState() => _ViewInventoryScreenState();
}

class _ViewInventoryScreenState extends State<ViewInventoryScreen> {
  late String name;
  late String quantity;
  late String location;
  late String position;
  late String imageUrl;

  @override
  void initState() {
    if (widget.checkList != null) {
      name = widget.checkList!.name;
      quantity = widget.checkList!.quantity;
      location = widget.checkList!.productLocation;
      position = widget.checkList!.productPosition;
      imageUrl = widget.checkList!.imageUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TAG"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
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
            ),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Product Name'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: name),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Product Quantity'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: quantity),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Product Location'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: location),
            const SizedBox(height: 10.0),
            const TextWidget(text: 'Position in Warehouse'),
            const SizedBox(height: 10.0),
            SizedBoxWidget(text: position),
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
