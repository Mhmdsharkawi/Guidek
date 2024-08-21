import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceLinksScreen extends StatefulWidget {
  final String subjectName;

  ResourceLinksScreen({required this.subjectName});

  @override
  _ResourceLinksScreenState createState() => _ResourceLinksScreenState();
}

class _ResourceLinksScreenState extends State<ResourceLinksScreen> {
  Map<String, dynamic> _subjectResources = {};

  @override
  void initState() {
    super.initState();
    _fetchSubjectResources();
  }

  Future<void> _fetchSubjectResources() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse('https://guidekproject.onrender.com/subjects/subject_resources/${widget.subjectName}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Print the entire API response for debugging
        print('API Response: $data');

        setState(() {
          _subjectResources = data['subject_resources'] ?? {};
          print('Parsed Resources: $_subjectResources');
        });
      } else {
        throw Exception('Failed to load subject resources');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  Widget _buildLinkField(String label, String? link) {
    final Color _appBarColor = Color(0xFF318C3C); // AppBar color

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: link ?? 'Link not available',
              readOnly: true,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: _appBarColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _appBarColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _appBarColor),
                ),
                labelStyle: TextStyle(color: _appBarColor),
              ),
              cursorColor: _appBarColor, // Set the cursor color
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: _appBarColor),
            onPressed: link != null ? () => _copyToClipboard(link) : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color _appBarColor = Color(0xFF318C3C); // Match the AppBar color
    final Color _textColor = Colors.white; // Color for text
    final Color _iconColor = Colors.black87;

    print('Building UI with resources: $_subjectResources'); // Debug statement

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subjectName,
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            color: _textColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _iconColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Center vertically
              children: [
                _buildLinkField('Book', _subjectResources['book']),
                _buildLinkField('Slides', _subjectResources['slides']),
                _buildLinkField('Course Plan', _subjectResources['course_plan']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
