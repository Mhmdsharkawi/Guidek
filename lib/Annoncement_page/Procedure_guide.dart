import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guidek_project1/Annoncement_page/procedure_detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProcedureGuide extends StatefulWidget {
  const ProcedureGuide({super.key});
  @override
  _ProcedureGuideState createState() => _ProcedureGuideState();
}

class _ProcedureGuideState extends State<ProcedureGuide> {
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
    final String url = 'https://guidekproject.onrender.com/transactions/all_transactions';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> transactions = data['Transactions'];

      setState(() {
        items = transactions.map((transaction) => transaction as Map<String, dynamic>).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void navigateToDetailScreen(String roomName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcedureDetailScreen(procedurename: roomName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Procedure Guide',
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
                  if (item['name'].toLowerCase().contains(searchQuery)) {
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
