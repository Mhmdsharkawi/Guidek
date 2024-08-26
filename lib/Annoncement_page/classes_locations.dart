import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadData();
  }

  Future<void> loadData() async {
    final String url = 'https://guidekproject.onrender.com/rooms/all_rooms';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('No JWT token found');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rooms = data['rooms'];

        setState(() {
          items = rooms.map((room) => room as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data. Please try again.')),
      );
    }
  }

  void navigateToDetailScreen(String roomName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailScreen(roomName: roomName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((item) {
      return item['name'].toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'classes'.tr(),
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
            image: AssetImage('assets/last_background.jpg'),
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
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'search'.tr(),
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
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                child: Text(
                  'No results found'.tr(),
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.separated(
                itemCount: filteredItems.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: appBarColor,
                    height: 1.0,
                  );
                },
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          fontFamily: 'Acumin Variable Concept',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {
                      navigateToDetailScreen(item['name']);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
