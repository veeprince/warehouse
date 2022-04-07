import 'package:flutter/material.dart';
import 'package:warehouse/common_widgets/slide_left.dart';
import 'package:warehouse/common_widgets/slide_right.dart';
import 'package:warehouse/device/screens/view_screen.dart';

import 'add_with_user.dart';
import '../models/checklist_model.dart';
import '../models/database_helper.dart';

class ListDeviceItem extends StatelessWidget {
  final CheckList checkList;
  final String docId;

  // ignore: use_key_in_widget_constructors
  const ListDeviceItem(this.checkList, this.docId);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Dismissible(
        key: Key(checkList.name),
        background: const SlideRightWidget(),
        secondaryBackground: const SlideLeftWidget(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Are you sure you want to delete ${checkList.name}'s data?"),
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
                                Navigator.of(context).pop();
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
                                DatabaseHelper.deleteChecklist(docId: docId);
                                // FirebaseStorage.instance.refFromURL(url)
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
            return res;
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTodoScreen(
                          checkList: checkList,
                          docId: docId,
                        ),
                    fullscreenDialog: true));
          }
          return null;
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewTodoScreen(
                          checkList: checkList,
                          docId: docId,
                        )));
            //Show all the list without editing it
          },
          title: Text(
            checkList.deviceDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 30.0),
          ),
          subtitle: Text(
            checkList.name,
            overflow: TextOverflow.ellipsis,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          trailing: Text(
            checkList.deviceLocation,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
