import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QAScreen extends StatefulWidget {
  const QAScreen({super.key});
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  List<Map<String, String>> _qaData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQAData();
  }

  Future<void> _loadQAData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse('https://guidekproject.onrender.com/faq/all_qa'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> qaList = data['QA'];
        setState(() {
          _qaData = qaList.map((item) => {
            'question': item['question'] as String,
            'answer': item['answer'] as String,
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Q&A data');
      }
    } catch (e) {
      print('Error loading Q&A data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        title: Text('Q&A'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: _qaData.length,
          itemBuilder: (context, index) {
            final item = _qaData[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['question'] ?? '',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF318c3c),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['answer'] ?? '',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
