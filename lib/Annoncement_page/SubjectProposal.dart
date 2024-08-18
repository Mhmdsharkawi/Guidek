import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubjectProposal extends StatefulWidget {
  @override
  _SubjectProposalState createState() => _SubjectProposalState();
}

class _SubjectProposalState extends State<SubjectProposal> {
  final _fullNameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  List<String> _majors = [];
  List<String> _filteredSubjects = [];
  List<String> _subjectList = [];
  String? _selectedSubject;
  String? _selectedMajor;
  final Color _appBarColor = Color(0xFF318c3c);
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _loadMajorsAndSubjects();
  }

  Future<void> _loadMajorsAndSubjects() async {
    // Load majors and subjects from a JSON file in assets
    final String response = await rootBundle.loadString('assets/majors_subjects.json');
    final Map<String, dynamic> data = json.decode(response);

    setState(() {
      _data = data;
      _majors = data.keys.toList();
      _filteredSubjects = [];
    });

    // Fetch subjects from the API
    await _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    try {
      // Make an HTTP GET request to fetch subjects from the API
      final response = await http.get(Uri.parse('https://guidekproject.onrender.com/subjects/all_subjects'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<String> subjects = (data['subjects'] as List<dynamic>)
            .map((subject) => subject['name'] as String)
            .toList();

        setState(() {
          _subjectList = subjects;
        });
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      print('Error fetching subjects: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load subjects. Please try again.')),
      );
    }
  }

  void _updateSubjects(String? major) {
    if (major != null && _data != null) {
      final majorData = _data![major];
      if (majorData != null) {
        _filteredSubjects = List<String>.from(majorData['subjects'] as List);
      } else {
        _filteredSubjects = [];
      }
      _selectedSubject = null; // Reset selected subject
    } else {
      _filteredSubjects = _subjectList; // Use the full list of subjects
    }
  }

  Future<void> _submitForm() async {
    if (_selectedSubject == null || _selectedMajor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a major and subject')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    final data = {
      'subject_name': _selectedSubject,
    };

    try {
      // Make an HTTP POST request to submit the selected subject
      final response = await http.post(
        Uri.parse('https://guidekproject.onrender.com/classes/request_class'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        setState(() {
          _selectedSubject = null;
          _selectedMajor = null;
        });
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    } catch (e) {
      print('Error submitting form: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Proposal'),
        backgroundColor: _appBarColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800), // Adjust maxWidth as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Major Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedMajor,
                  hint: Text('Select Major'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMajor = newValue;
                      _updateSubjects(newValue);
                    });
                  },
                  items: _majors.map((major) {
                    return DropdownMenuItem<String>(
                      value: major,
                      child: Text(major),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Major',
                    labelStyle: TextStyle(color: _appBarColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Subject Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  hint: Text('Select Subject'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSubject = newValue;
                    });
                  },
                  items: _filteredSubjects.isNotEmpty
                      ? _filteredSubjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250),  
                        child: Text(
                          subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList()
                      : _subjectList.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: Text(
                          subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: TextStyle(color: _appBarColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _appBarColor, // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
