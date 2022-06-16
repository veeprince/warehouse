import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:warehouse/common_widgets/clear_tags.dart';

// ignore: must_be_immutable
class TagWidget extends StatefulWidget {
  List<String> tagGetter = [];

  TextfieldTagsController textFieldController = TextfieldTagsController();

  TagWidget({
    Key? key,
    required this.tagGetter,
    required this.textFieldController,
  }) : super(key: key);

  @override
  State<TagWidget> createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  late double _distanceToField;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      initialTags: widget.tagGetter,
      textfieldTagsController: widget.textFieldController,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              controller: tec,
              focusNode: fn,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 3.0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 123, 123, 123),
                    width: 1.0,
                  ),
                ),
                hintTextDirection: TextDirection.rtl,
                hintStyle: GoogleFonts.aBeeZee(
                  color: const Color.fromARGB(255, 143, 140, 140),
                ),
                hintText: widget.textFieldController.hasTags
                    ? ''
                    : "Enter the tags seperated by comma",
                errorText: error,
                suffixIcon:
                    ClearTagWidget(controller: widget.textFieldController),
                prefixIconConstraints:
                    BoxConstraints(maxWidth: _distanceToField * 0.74),
                prefixIcon: tags.isNotEmpty
                    ? SingleChildScrollView(
                        controller: sc,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: tags.map((String tag) {
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                              color: Color.fromARGB(255, 163, 163, 164),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: Text(
                                    '#$tag',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    // ignore: avoid_print
                                    print("$tag selected");
                                  },
                                ),
                                const SizedBox(width: 4.0),
                                InkWell(
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 14.0,
                                    color: Color.fromARGB(255, 233, 233, 233),
                                  ),
                                  onTap: () {
                                    onTagDelete(tag);
                                  },
                                )
                              ],
                            ),
                          );
                        }).toList()),
                      )
                    : null,
              ),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          );
        });
      },
    );
  }
}
