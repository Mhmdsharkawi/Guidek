import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'location_detail.dart';
import 'package:geolocator/geolocator.dart';

class ClassesLocationsScreen extends StatefulWidget {
  const ClassesLocationsScreen({super.key});
  @override
  _ClassesLocationsState createState() => _ClassesLocationsState();
}

class _ClassesLocationsState extends State<ClassesLocationsScreen> {
  List<Map<String, dynamic>> items = [];
  String searchQuery = '';
  final Color appBarColor = Color(0xFF318c3c);

  void getLocation() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/locations.json');
    print('Response: $response'); // Add this line
    final List<dynamic> data = json.decode(response);
    print('Data: $data'); // Add this line
    setState(() {
      items = data.map((item) => item as Map<String, dynamic>).toList();
    });
  }

  void navigateToDetailScreen(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Classes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: appBarColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: appBarColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: appBarColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: appBarColor),
                  ),
                ),
                cursorColor: appBarColor, // Ensure cursor color matches app bar color
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) {
                return Divider(
                  color: appBarColor, // Divider color matches app bar color
                  height: 1.0,
                );
              },
              itemBuilder: (context, index) {
                final item = items[index];
                if (item['class_name'].toLowerCase().contains(searchQuery)) {
                  return ListTile(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(item['class_name']),
                    ),
                    onTap: () {
                      navigateToDetailScreen(item);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
