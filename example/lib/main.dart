import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country State City Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country State City Picker Example'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CountryStateCityPicker(
                // country: country,
                // state: state,color: Color(0xff1f2128),
                containerColor:  Color(0xff1f2128),
                city: city,
                dialogColor: Colors.grey.shade200,
                textFieldDecoration: InputDecoration(
                  
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("${country.text}, ${state.text}, ${city.text}")
            ],
          )),
    );
  }
}
