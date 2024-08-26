import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guidek_project1/Annoncement_page/procedure_detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('Access token is missing. Please log in again.');
      }

      final String  url = 'https://guidekproject.onrender.com/transactions/all_transactions';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> transactions = data['Transactions'];

        setState(() {
          items = transactions.map((transaction) => transaction as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:const Text('Failed to load transactions. Please try again.')),
      );
    }
  }


  void navigateToDetailScreen(String procedureName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcedureDetailScreen(procedurename: procedureName),
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
          'procedure guide'.tr(),
          style:const TextStyle(
            fontFamily: 'Acumin Variable Concept',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration:const BoxDecoration(
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
                        style:const TextStyle(
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
