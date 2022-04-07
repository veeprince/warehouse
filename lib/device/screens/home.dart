import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/app_bar.dart';
import 'package:warehouse/device/models/checklist_model.dart';
import 'package:warehouse/device/models/database_helper.dart';
import 'package:warehouse/device/screens/add_with_user.dart';
import 'package:warehouse/device/screens/add_without_user.dart';
import 'package:warehouse/device/screens/list_item.dart';
import 'package:warehouse/device/screens/view_without_user.dart';
import 'package:warehouse/device/widgets/show_search.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  PageController page = PageController();

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
          title: const Text(
            "TAG Devices",
          ),
          leading: const CustomAppBarWidget(),
          centerTitle: true,
          actions: <Widget>[
            const ShowSearch(),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text("Does this device have a user?"),
                          actions: <Widget>[
                            Center(
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const AddWithoutUser(),
                                          ))
                                          .then((value) =>
                                              Navigator.of(context).pop());
                                    },
                                  ),
                                  const SizedBox(
                                    width: 200,
                                  ),
                                  ElevatedButton(
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const AddTodoScreen(),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              controller: page,
              style: SideMenuStyle(
                  displayMode: SideMenuDisplayMode.auto,
                  hoverColor: const Color.fromARGB(255, 146, 147, 147),
                  selectedColor: const Color.fromARGB(255, 95, 93, 93),
                  selectedTitleTextStyle: const TextStyle(color: Colors.white),
                  selectedIconColor: Colors.white,
                  // backgroundColor: Colors.amber
                  // compactSideMenuWidth: 20,
                  openSideMenuWidth: 200),
              title: Column(
                children: const [
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              items: [
                SideMenuItem(
                  priority: 0,
                  title: 'With Users',
                  onTap: () {
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.supervisor_account),
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'Warehouse',
                  onTap: () {
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.storage),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: page,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Center(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: DatabaseHelper.getChecklist(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10.0),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var checklistData =
                                    snapshot.data!.docs[index].data()!;

                                String docId = snapshot.data!.docs[index].id;

                                final CheckList checkList = CheckList.fromJSON(
                                    checklistData as Map<String, dynamic>);
                                if (checklistData["name"] != "N/A") {
                                  return ListDeviceItem(checkList, docId);
                                }
                                return Container();
                                // return ListNoUserDeviceItem(
                                //     checkList, docId);
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
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Center(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: DatabaseHelper.getChecklist(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10.0),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var checklistData =
                                    snapshot.data!.docs[index].data()!;

                                String docId = snapshot.data!.docs[index].id;

                                final CheckList checkList = CheckList.fromJSON(
                                    checklistData as Map<String, dynamic>);
                                if (checklistData["name"] == "N/A") {
                                  return ListWithoutUser(checkList, docId);
                                }
                                return Container();
                                // return ListNoUserDeviceItem(
                                //     checkList, docId);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
