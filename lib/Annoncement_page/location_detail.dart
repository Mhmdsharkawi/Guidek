import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LocationDetailScreen extends StatefulWidget {
  final String roomName;

  LocationDetailScreen({required this.roomName});

  @override
  _LocationDetailScreenState createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  late Future<Map<String, dynamic>> roomDetails;

  @override
  void initState() {
    super.initState();
    roomDetails = fetchRoomDetails(widget.roomName);
  }

  Future<Map<String, dynamic>> fetchRoomDetails(String roomName) async {
    final String url = 'https://guidekproject.onrender.com/rooms/get_location/$roomName';

    try {
      // Retrieve the JWT token from SharedPreferences
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

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to load room details';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error fetching room details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        title: Text(
          widget.roomName,
          textAlign: TextAlign.right,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: roomDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final data = snapshot.data!;
          final location = data['location'];
          final direction = data['direction'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () async {
                          if (await canLaunch(location)) {
                            await launch(location);
                          } else {
                            throw 'Could not open the map.';
                          }
                        },
                        child: Image.asset(
                          'assets/location.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                      const SizedBox(height: 8.0), // Space between the image and text
                      Text(
                        'انقر على الصورة للحصول على الموقع',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // You can adjust the color if needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Description area
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      direction,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
