// import 'package:flutter/material.dart';

// class PopUpMenu extends StatefulWidget {
//   const PopUpMenu({Key? key}) : super(key: key);

//   @override
//   PopUpState createState() => PopUpState();
// }

// class PopUpState extends State<PopUpMenu> {
//   late String codeDialog;
//   String valueText = '';
//   String locationText = '';
//   TextEditingController textFieldController = TextEditingController();
//   TextEditingController locationTextFieldController = TextEditingController();

//   void displayTextInputDialog() async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Enter Quantity and Location'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       valueText = value;
//                     });
//                   },
//                   controller: textFieldController,
//                   decoration: const InputDecoration(hintText: "Quantity"),
//                 ),
//                 TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       locationText = value;
//                     });
//                   },
//                   controller: locationTextFieldController,
//                   decoration:
//                       const InputDecoration(hintText: "Delivery Location"),
//                 ),
//               ],
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('CANCEL'),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               TextButton(
//                 child: const Text('REQUEST'),
//                 onPressed: () {
//                   setState(() {
//                     codeDialog = valueText;
//                     Navigator.pop(context);
//                     textFieldController.clear();
//                     locationTextFieldController.clear();
//                   });
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }
