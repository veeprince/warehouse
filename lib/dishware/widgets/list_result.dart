import 'package:flutter/material.dart';
import 'package:warehouse/dishware/models/dishware_checklist_model.dart';
import 'package:warehouse/dishware/screens/view_dishware_screen.dart';

class ViewButton extends StatelessWidget {
  final DishwareCheckList checkList;
  final String docId;
  const ViewButton(this.checkList, this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.open_in_full),
        title: const Text('View'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewDishwareScreen(
                        checkList: checkList,
                        docId: docId,
                      ))).whenComplete(() => Navigator.of(context).pop());
        });
  }
}
