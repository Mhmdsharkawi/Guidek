import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class StudyResourcesScreen extends StatefulWidget {
  @override
  _StudyResourcesScreenState createState() => _StudyResourcesScreenState();
}

class _StudyResourcesScreenState extends State<StudyResourcesScreen> {
  Map<String, dynamic> _data = {};
  List<String> _allSubjects = [];
  List<String> _filteredSubjects = [];
  TextEditingController _searchController = TextEditingController();
  final Color _appBarColor = Color(0xFF318C3C); // Match the AppBar color
  final Color _secondaryColor = Color(0xFFFDCD90); // Yellow color for the bar
  final Color _textColor = Colors.white; // Color for text, matching HelpSupportPage
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
    final String response = await rootBundle.loadString('assets/subjects.json');
    final Map<String, dynamic> data = json.decode(response);

    setState(() {
      _data = data;
      _allSubjects = data.values
          .expand((majors) => (majors['subjects'] as List).map((subject) => subject['name'] as String))
          .toList();
      _filteredSubjects = List.from(_allSubjects);
    });
  }

  void _filterSubjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSubjects = _allSubjects.where((subject) {
        return subject.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subjects', // Title text, can be customized
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
                          hintText: 'Search subjects...',
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
                        final subjectName = _filteredSubjects[index];
                        final subjectData = _data.entries
                            .expand((entry) => (entry.value['subjects'] as List).where((sub) => sub['name'] == subjectName))
                            .first;

                        return ExpansionTile(
                          title: Text(subjectName, style: TextStyle(color: _appBarColor)),
                          iconColor: _appBarColor, // Color for the expansion icon
                          children: <Widget>[
                            if (subjectData['books'] != null)
                              ListTile(
                                title: Text('Books', style: TextStyle(color: _appBarColor)),
                                onTap: () => _launchUrl(subjectData['books']),
                              ),
                            if (subjectData['slides'] != null)
                              ListTile(
                                title: Text('Slides', style: TextStyle(color: _appBarColor)),
                                onTap: () => _launchUrl(subjectData['slides']),
                              ),
                            if (subjectData['coursePlan'] != null)
                              ListTile(
                                title: Text('Course Plan', style: TextStyle(color: _appBarColor)),
                                onTap: () => _launchUrl(subjectData['coursePlan']),
                              ),
                          ],
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
