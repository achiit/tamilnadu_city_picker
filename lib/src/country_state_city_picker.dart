import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './model/district_model.dart';
import './model/taluk_model.dart';

class CountryStateCityPicker extends StatefulWidget {
  final TextEditingController districtController;
  final TextEditingController talukController;
  final InputDecoration? textFieldDecoration;
  final Color? dialogColor;
  final Color? containerColor;

  const CountryStateCityPicker({
    Key? key,
    required this.districtController,
    required this.talukController,
    this.containerColor,
    this.textFieldDecoration,
    this.dialogColor,
  }) : super(key: key);

  @override
  State<CountryStateCityPicker> createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  final List<DistrictModel> _districtList = [];
  final List<TalukModel> _talukList = [];
  List<TalukModel> _filteredTalukList = [];
  String _selectedDistrict = '';

  @override
  void initState() {
    super.initState();
    _getDistricts();
    _getTaluks();
  }

  Future<void> _getDistricts() async {
    _districtList.clear();
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/district.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _districtList.addAll(
          body.map((dynamic item) => DistrictModel.fromJson(item)).toList());
    });
  }

  Future<void> _getTaluks() async {
    _talukList.clear();
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/taluk.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _talukList.addAll(
          body.map((dynamic item) => TalukModel.fromJson(item)).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add District TextField
        TextField(
          readOnly: true,
          onTap: () {
            _showDistrictDialog(context);
          },
          controller: widget.districtController,
          decoration: defaultDecoration.copyWith(hintText: 'Select district'),
        ),
        const SizedBox(height: 8.0),

        // Add Taluk TextField
        TextField(
          readOnly: true,
          onTap: () {
            _showTalukDialog(context);
          },
          controller: widget.talukController,
          decoration: defaultDecoration.copyWith(hintText: 'Select taluk'),
        ),
      ],
    );
  }

  void _showDistrictDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showGeneralDialog(
      barrierLabel: 'District',
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
                    color: Color(0xffF2FAEB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      ///Text Field
                      TextField(
                        controller: controller,
                        onChanged: (val) {
                          setState(() {
                            _selectedDistrict = val;
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
                          itemCount: _districtList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                widget.districtController.text =
                                    _districtList[index].name;
                                _selectedDistrict = _districtList[index].name;
                                _filteredTalukList = _talukList
                                    .where((t) =>
                                        t.districtId == _districtList[index].id)
                                    .toList();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, left: 10.0, right: 10.0),
                                child: Text(_districtList[index].name,
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
                          _selectedDistrict = '';
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

  void _showTalukDialog(BuildContext context) {
    if (_selectedDistrict.isEmpty) {
      // Show error message or handle the case where district is not selected
      return;
    }

    final TextEditingController controller = TextEditingController();

    showGeneralDialog(
      barrierLabel: 'Taluk(first select the district)',
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
                    color: Color(0xffF2FAEB),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      ///Text Field
                      TextField(
                        controller: controller,
                        onChanged: (val) {
                          setState(() {
                            _filteredTalukList = _talukList
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
                          itemCount: _filteredTalukList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                widget.talukController.text =
                                    _filteredTalukList[index].name;
                                controller.clear();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, left: 10.0, right: 10.0),
                                child: Text(_filteredTalukList[index].name,
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
                          _filteredTalukList = _talukList;
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
      hintStyle: TextStyle(color: Colors.black),
      suffixIcon: Icon(Icons.arrow_drop_down),
      border: OutlineInputBorder());
}
