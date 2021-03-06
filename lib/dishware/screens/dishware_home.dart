import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/blocs/auth_block.dart';
import 'package:warehouse/common_widgets/app_bar.dart';
import 'package:warehouse/dishware/screens/add_dishware_screen.dart';
import 'package:warehouse/dishware/widgets/list_dishware.dart';
import 'package:warehouse/dishware/widgets/search_firebase.dart';
import '../models/dishware_checklist_model.dart';
import '../models/dishware_database_helper.dart';
import 'package:warehouse/functions.dart';

class DishwareHomePage extends StatefulWidget {
  const DishwareHomePage({Key? key}) : super(key: key);

  @override
  DishwareHomePageState createState() => DishwareHomePageState();
}

class DishwareHomePageState extends State<DishwareHomePage>
    with SingleTickerProviderStateMixin, DishFunctions {
  String userEmail = "";
  bool visibilityToggle = false;
  @override
  initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);

    authBloc.currentUser.listen((event) {
      userEmail = event!.email!;
      if (userList.contains(userEmail)) {
        setState(() {
          visibilityToggle = true;
        });
      } else {
        setState(() {
          visibilityToggle = false;
        });
      }
    });
    super.initState();
  }

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
          title: const Text("TAG Plateware"),
          centerTitle: true,
          leading: const CustomAppBarWidget(),
          actions: <Widget>[
            const SearchFirebase(),
            Visibility(
              visible: visibilityToggle,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddDishwareScreen(),
                    ));
                  },
                  icon: const Icon(Icons.add)),
            )
          ],
        ),
        body: DelayedDisplay(
          delay: const Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: DishwareDatabaseHelper.getDishwareChecklist(),
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

                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var checklistData = snapshot.data!.docs[index].data()!;

                        String docId = snapshot.data!.docs[index].id;

                        final DishwareCheckList checkList =
                            DishwareCheckList.fromJSON(
                                checklistData as Map<String, dynamic>);
                        // print(checkList);

                        // print(snapshot.data!.docs[index].data());
                        return ListDishwareItem(checkList, docId);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 1),
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

// ignore: must_be_immutable
