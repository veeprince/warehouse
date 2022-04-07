import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class PersonalizedDisplay extends StatefulWidget {
  const PersonalizedDisplay({Key? key}) : super(key: key);

  @override
  State<PersonalizedDisplay> createState() => _PersonalizedDisplayState();
}

class _PersonalizedDisplayState extends State<PersonalizedDisplay> {
  List<String> items = [
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
        isExpanded: true,
        hint: const Center(
          child: Text(
            'Select Year',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 131, 130, 130),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Center(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
        },
      )),
    );
  }
}
