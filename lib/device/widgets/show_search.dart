import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:warehouse/device/screens/home.dart';
import 'package:warehouse/common_widgets/container_widget.dart';
import 'package:warehouse/common_widgets/form_field.dart';
import 'package:warehouse/common_widgets/text_widget.dart';
import '../models/device_model.dart';

class ShowSearch extends StatefulWidget {
  const ShowSearch({Key? key}) : super(key: key);

  @override
  ShowSearchState createState() => ShowSearchState();
}

class ShowSearchState extends State<ShowSearch>
    with SingleTickerProviderStateMixin {
  var name = '';
  var jobTitle = '';
  var serial = '';
  var deviceLocation = '';
  var deviceDescription = '';
  static List<Device> device = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Device")
        .get()
        .then((QuerySnapshot querysnapshot) {
      for (var doc in querysnapshot.docs) {
        setState(() {
          device.add(Device(
            name: doc['name'],
            year: doc['year'],
            jobTitle: doc['jobTitle'],
            serial: doc['serial'],
            operatingSystem: doc['operatingSystem'],
            deviceLocation: doc['deviceLocation'],
            deviceDescription: doc['deviceDescription'],
          ));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: SearchPage<Device>(
              // onQueryUpdate: (s) {},
              showItemsOnEmpty: true,

              items: device,
              searchLabel: 'Search warehouse',
              suggestion: const Center(
                child:
                    Text('Search products by device name, owner or quantity'),
              ),
              failure: const Center(
                child: Text('No product found :('),
              ),
              filter: (device) => [
                device.name,
                device.serial,
                device.deviceLocation,
                device.deviceDescription,
                device.jobTitle,
              ],
              builder: (product) {
                return ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.deviceDescription),
                    trailing: Text(product.deviceLocation),
                    onTap: () {
                      name = product.name;
                      deviceDescription = product.deviceDescription;
                      jobTitle = product.jobTitle;
                      deviceLocation = product.deviceLocation;
                      serial = product.serial;
                      showModalBottomSheet(
                        enableDrag: true,
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.open_in_full),
                              title: const Text('View'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text("SearchPage"),
                                          centerTitle: true,
                                        ),
                                        body: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                  text: 'Employee Name',
                                                ),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.name),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                  text: 'Job Title',
                                                ),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.jobTitle),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                  text: 'Device Description',
                                                ),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product
                                                        .deviceDescription),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                  text: 'Device Location',
                                                ),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text:
                                                        product.deviceLocation),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const TextWidget(
                                                  text: 'Quantity',
                                                ),
                                                const SizedBox(height: 10.0),
                                                ContainerWidget(
                                                    text: product.serial),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            ),
                            const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: ShowFormField()),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("Device")
                                    .where("name", isEqualTo: product.name)
                                    .get()
                                    .then((value) {
                                  for (var element in value.docs) {
                                    FirebaseFirestore.instance
                                        .collection("Device")
                                        .doc(element.id)
                                        .delete();
                                  }
                                });

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const MyHomePage(),
                                    ),
                                    (route) => route.isFirst);
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          );
        },
        icon: const Icon(Icons.search));
  }
}
