import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QAScreen extends StatefulWidget {
  const QAScreen({super.key});
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  List<Map<String, String>> _qaData = [];

  final Color primaryColor = Color(0xFF318C3C);
  final Color secondaryColor = Color(0xFFFDCD90);
  final Color grayColor = Colors.grey[600]!;

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
        backgroundColor: primaryColor,
        title: Text(
          'FAQ',
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
            Expanded(
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['question'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['answer'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ],
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
