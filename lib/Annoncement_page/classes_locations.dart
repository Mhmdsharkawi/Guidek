import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'location_detail.dart';

class ClassesLocationsScreen extends StatefulWidget {
  const ClassesLocationsScreen({super.key});
  @override
  _ClassesLocationsState createState() => _ClassesLocationsState();
}

class _ClassesLocationsState extends State<ClassesLocationsScreen> {
  List<Map<String, dynamic>> items = [];
  String searchQuery = '';
  final Color appBarColor = Color(0xFF318c3c);
  final Color secondaryColor = Color(0xFFFDCD90);  

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/locations.json');
    print('Response: $response'); // Logging response
    final List<dynamic> data = json.decode(response);
    print('Data: $data'); // Logging parsed data
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
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Classes',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background2.jpeg'),  
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 12,
              color: secondaryColor,  
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: appBarColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  cursorColor: appBarColor,
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
                    color: appBarColor,  
                    height: 1.0,
                  );
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  if (item['class_name'].toLowerCase().contains(searchQuery)) {
                    return ListTile(
                      title: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          item['class_name'],
                          style: TextStyle(
                            fontFamily: 'Acumin Variable Concept',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
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
      ),
    );
  }
}
