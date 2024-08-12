import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  LocationDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            item['class_name'],
            textAlign: TextAlign.right,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image button to open Google Maps
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0, // Remove shadow
                padding: EdgeInsets.zero,
              ),
              onPressed: () async {
                final url = item['gps_link'];
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not open the map.';
                }
              },
              child: Image.asset(
                'assets/location.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          // Description area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Directionality(
              textDirection: TextDirection.rtl, // Set text direction to RTL
              child: Text(
                item['description'],
                textAlign: TextAlign.center, // Center text within its container
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
