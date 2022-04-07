import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/app_bar.dart';
import 'package:warehouse/inventory/screens/add_inventory_screen.dart';
import 'package:warehouse/inventory/widgets/inventory_list.dart';
import 'package:warehouse/inventory/widgets/search_widget.dart';
import '../models/inventory_checklist_model.dart';
import '../models/inventory_database_helper.dart';

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({Key? key}) : super(key: key);

  @override
  InventoryHomePageState createState() => InventoryHomePageState();
}

class InventoryHomePageState extends State<InventoryHomePage>
    with SingleTickerProviderStateMixin {
  var amount = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TAG Warehouse"),
          centerTitle: true,
          leading: const CustomAppBarWidget(),
          actions: <Widget>[
            const SearchInventory(),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddInventoryScreen()));
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: DelayedDisplay(
          delay: const Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: InventoryDatabaseHelper.getInventoryChecklist(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No data found",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }

                    return ListView.builder(
                      // separatorBuilder: (context, index) =>
                      //     const SizedBox(height: 10.0),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        amount = index;
                        var checklistData = snapshot.data!.docs[index].data()!;

                        String docId = snapshot.data!.docs[index].id;

                        final InventoryCheckList checkList =
                            InventoryCheckList.fromJSON(
                                checklistData as Map<String, dynamic>);

                        return ListInventoryItem(checkList, docId);
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
