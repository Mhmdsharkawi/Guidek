import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecommandedSubjects extends StatefulWidget {
  @override
  _RecommandedSubjectsState createState() => _RecommandedSubjectsState();
}

class _RecommandedSubjectsState extends State<RecommandedSubjects> {
  List<String> _filteredSubjects = [];
  String? _selectedMajor;
  int? _selectedYear = 1;
  String? _selectedSemester = 'First';

  final Color _primaryColor = Color(0xFF318C3C);
  final Color _secondaryColor = Color(0xFFFDCD90);

  @override
  void initState() {
    super.initState();
    _loadMajorName();
  }

  Future<void> _loadMajorName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMajor = prefs.getString('userMajor') ?? ''; // Use the correct key
    });
    print('Loaded Major Name: $_selectedMajor');
  }

  Future<void> _fetchSuggestedSubjects() async {
    if (_selectedMajor == null || _selectedMajor!.isEmpty) {
      print('Major name is not available.');
      return;
    }

    final year = _selectedYear;
    final semester = _selectedSemester == 'First' ? 1 : 2;

    final url = Uri.parse('https://guidekproject.onrender.com/subjects/suggested_subjects')
        .replace(queryParameters: {
      'major_name': _selectedMajor!,
      'year': year.toString(),
      'semester': semester.toString(),
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _filteredSubjects = List<String>.from(data['suggested_subjects']);
        });
      } else {
        print('Failed to load suggested subjects');
      }
    } catch (error) {
      print('Error fetching suggested subjects: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suggested Subjects',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _primaryColor,
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
              color: _secondaryColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedYear,
                            decoration: InputDecoration(
                              labelText: 'Year',
                              labelStyle: TextStyle(color: _primaryColor),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: _primaryColor),
                              ),
                            ),
                            items: [1, 2, 3, 4].map((int year) {
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text(year.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedSemester,
                            decoration: InputDecoration(
                              labelText: 'Semester',
                              labelStyle: TextStyle(color: _primaryColor),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: _primaryColor),
                              ),
                            ),
                            items: ['First', 'Second'].map((String semester) {
                              return DropdownMenuItem<String>(
                                value: semester,
                                child: Text(semester),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSemester = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredSubjects.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_filteredSubjects[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _fetchSuggestedSubjects,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Suggest Subjects',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
