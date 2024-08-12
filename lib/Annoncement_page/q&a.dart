import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class QAScreen extends StatefulWidget {
  const QAScreen({super.key});
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  List<Map<String, String>> _qaData = [];

  @override
  void initState() {
    super.initState();
    _loadQAData();
  }

  Future<void> _loadQAData() async {
    // Load the JSON file from assets
    final String response = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      _qaData = data.map((item) => {
        'question': item['question'] as String,
        'answer': item['answer'] as String,
      }).toList();
    });
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
      body: Directionality(
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
