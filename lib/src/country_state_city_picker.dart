import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './model/city_model.dart';

class CountryStateCityPicker extends StatefulWidget {
  final TextEditingController city;
  final InputDecoration? textFieldDecoration;
  final Color? dialogColor;
  final Color? containerColor;

  const CountryStateCityPicker({
    Key? key,
    required this.city,
    this.containerColor,
    this.textFieldDecoration,
    this.dialogColor,
  }) : super(key: key);

  @override
  State<CountryStateCityPicker> createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  final List<CityModel> _cityList = [];
  List<CityModel> _citySubList = [];
  String _title = 'City';

  @override
  void initState() {
    super.initState();
    _getCity();
  }

  Future<void> _getCity() async {
    _cityList.clear();
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/city.json');
    List<dynamic> body = json.decode(jsonString);

    setState(() {
      _cityList.addAll(
          body.map((dynamic item) => CityModel.fromJson(item)).toList());
      _citySubList = _cityList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField(
        //   readOnly: true,
        //   controller: TextEditingController(text: 'India'), // Set default value to India
        //   decoration: widget.textFieldDecoration == null
        //       ? defaultDecoration.copyWith(hintText: 'Country')
        //       : widget.textFieldDecoration
        //           ?.copyWith(hintText: 'Country'),
        // ),
        // const SizedBox(height: 8.0),

        // TextField(
        //   readOnly: true,
        //   controller: TextEditingController(text: 'Tamil Nadu'), // Set default value to Tamil Nadu
        //   decoration: widget.textFieldDecoration == null
        //       ? defaultDecoration.copyWith(hintText: 'State')
        //       : widget.textFieldDecoration
        //           ?.copyWith(hintText: 'State'),
        // ),
        const SizedBox(height: 8.0),

        Container(
          decoration: BoxDecoration(
              color: widget.containerColor ?? Colors.grey.shade200,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: widget.city,
            onTap: () {
              _showDialog(context);
            },
            decoration: widget.textFieldDecoration == null
                ? defaultDecoration.copyWith(hintText: 'Select city')
                : widget.textFieldDecoration?.copyWith(hintText: 'Select city'),
            readOnly: true,
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showGeneralDialog(
      barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (context, __, ___) {
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * .7,
                  margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: widget.dialogColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // const SizedBox(height: 10),
                      // Text(_title,
                      //     style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),

                      ///Text Field
                      TextField(
                        //style: TextStyle(color: Colors.white),

                        controller: controller,
                        onChanged: (val) {
                          setState(() {
                            _citySubList = _cityList
                                .where((element) => element.name
                                    .toLowerCase()
                                    .contains(controller.text.toLowerCase()))
                                .toList();
                          });
                        },
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Search here...",
                            hintStyle: TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            isDense: true,
                            prefixIcon: Icon(Icons.search)),
                      ),

                      ///Dropdown Items
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          itemCount: _citySubList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  widget.city.text = _citySubList[index].name;
                                  _citySubList = _cityList;
                                });
                                controller.clear();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, left: 10.0, right: 10.0),
                                child: Text(_citySubList[index].name,
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 16.0)),
                              ),
                            );
                          },
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0))),
                        onPressed: () {
                          _citySubList = _cityList;
                          controller.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  InputDecoration defaultDecoration = const InputDecoration(
      isDense: true,
      hintText: 'Select',
      hintStyle: TextStyle(color: Colors.white),
      suffixIcon: Icon(Icons.arrow_drop_down),
      border: OutlineInputBorder());
}
