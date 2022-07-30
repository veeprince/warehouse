// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
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
  late String quantity;
  late String color;
  late String imageUrl;
  late Map<String, dynamic> tags;
  List<Widget> textWidgetList = <Widget>[]; // Here we defined a list of widget!
  late Map<String, dynamic> locations;
  List<Widget> locationWidgetList = <Widget>[];
  var recase = RegExp(r'\b\w');
  @override
  void initState() {
    if (widget.checkList != null) {
      quantity = widget.checkList!.quantity;
      locations = widget.checkList!.locations;
      imageUrl = widget.checkList!.imageUrl;
      color = widget.checkList!.color;
      tags = widget.checkList!.tags;
    }
    // // for (int i = 0; i < tags.length; i++) {
    // for (var v in tags.keys) {
    //   print(v);

    //   //below is the solution
    //   // v.().forEach((i, value) {
    //   //   print('index=$i, value=$value');
    //   // });
    // }

    locationWidgetList.add(
      Text(
        "${locations.keys.join(" ").replaceAllMapped(recase, (match) => match.group(0)!.toUpperCase())}  ",
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
    textWidgetList.add(
      SelectableText(
        "${tags.keys.join(" ")
        // .replaceAllMapped(recase, (match) => match.group(0)!.toUpperCase())
        }  ",

        textAlign: TextAlign.center,

        // overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: GoogleFonts.aBeeZee(
          color: const Color.fromARGB(255, 255, 252, 252),
          fontSize: 20.0,
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
        title: const Text("TAG Plateware"),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400.0,
            height: 300.0,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              width: double.infinity,
              height: 280,
              alignment: Alignment.center,
              child: ClipRect(
                child: PhotoView(
                    basePosition: Alignment.center,
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    initialScale: PhotoViewComputedScale.covered,
                    backgroundDecoration: const BoxDecoration(
                        color: Color.fromARGB(256, 50, 50, 50)),
                    imageProvider:
                        CachedNetworkImageProvider(widget.checkList!.imageUrl)
                    // CachedNetworkImage(
                    //   fit: BoxFit.contain,
                    //   imageUrl: widget.checkList!.imageUrl,
                    //   progressIndicatorBuilder:
                    //       (context, url, downloadProgress) =>
                    //           LinearProgressIndicator(
                    //               value: downloadProgress.progress),
                    //   errorWidget: (context, url, error) =>
                    //       const Icon(Icons.error),
                    // ),
                    ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10.0),
              const TextWidget(text: 'Tags'),
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: textWidgetList,
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(
                color: Colors.grey,
              ),
              const TextWidget(text: 'Quantity'),
              const SizedBox(height: 5.0),
              SizedBoxWidget(text: quantity),
              const SizedBox(height: 10.0),
              const TextWidget(text: 'Color'),
              const SizedBox(height: 5.0),
              SizedBoxWidget(text: color
                  // .capitalize()
                  ),
              const SizedBox(height: 10.0),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
