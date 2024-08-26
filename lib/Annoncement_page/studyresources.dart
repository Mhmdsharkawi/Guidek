import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ResourceLinks.dart';

class StudyResourcesScreen extends StatefulWidget {
  @override
  _StudyResourcesScreenState createState() => _StudyResourcesScreenState();
}

class _StudyResourcesScreenState extends State<StudyResourcesScreen> {
  List<dynamic> _allSubjects = [];
  List<dynamic> _filteredSubjects = [];
  TextEditingController _searchController = TextEditingController();
  final Color _appBarColor =const Color(0xFF318C3C);
  final Color _secondaryColor = const Color(0xFFFDCD90);
  final Color _textColor = Colors.white;
  final Color _iconColor = Colors.black87;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      _filterSubjects();
    });
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.get(
      Uri.parse('https://guidekproject.onrender.com/subjects/all_subjects'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> subjects = data['subjects'];

      setState(() {
        _allSubjects = subjects;
        _filteredSubjects = List.from(_allSubjects);
      });
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  void _filterSubjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSubjects = _allSubjects.where((subject) {
        return subject['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToResourceLinks(String subjectName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResourceLinksScreen(subjectName: subjectName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'books_files'.tr(),
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
              color: _secondaryColor,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        cursorColor: _appBarColor,
                        decoration: InputDecoration(
                          hintText: 'search_subjects'.tr(),
                          prefixIcon: Icon(Icons.search, color: _appBarColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _appBarColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _appBarColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: _appBarColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final subject = _filteredSubjects[index];
                        final subjectName = subject['name'];

                        return ListTile(
                          title: Text(subjectName, style: TextStyle(color: _appBarColor)),
                          onTap: () => _navigateToResourceLinks(subjectName),
                        );
                      },
                      childCount: _filteredSubjects.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceLinks extends StatelessWidget {
  final String subjectName;

  ResourceLinks({required this.subjectName});

  @override
  Widget build(BuildContext context) {
    // Implement your ResourceLinks screen here
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: Center(
        child: Text('Resource links for $subjectName'),
      ),
    );
  }
}
