import 'package:flutter/material.dart';
import 'dart:convert';
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
  String? _selectedSubject;
  String? _selectedMajor;
  final Color _appBarColor = Color(0xFF318c3c);

  @override
  void initState() {
    super.initState();
    _loadMajorsAndSubjects();
  }

  Future<void> _loadMajorsAndSubjects() async {
    try {
      // Fetch majors from the API
      final majorsResponse = await http.get(Uri.parse('https://guidekproject.onrender.com/majors/all_majors'));

      if (majorsResponse.statusCode == 200) {
        final Map<String, dynamic> majorsData = jsonDecode(majorsResponse.body);
        final List<String> majors = (majorsData['majors'] as List<dynamic>)
            .map((major) => major['name'] as String)
            .toList();

        setState(() {
          _majors = majors;
          _filteredSubjects = [];
        });
      } else {
        throw Exception('Failed to load majors');
      }
    } catch (e) {
      print('Error fetching majors: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load majors. Please try again.')),
      );
    }
  }

  void _updateSubjects(String? major) async {
    if (major != null) {
      try {
        final subjectsResponse = await http.get(Uri.parse('https://guidekproject.onrender.com/majors/get_subjectsen/$major'));

        if (subjectsResponse.statusCode == 200) {
          final Map<String, dynamic> subjectsData = jsonDecode(subjectsResponse.body);
          final List<String> subjects = (subjectsData['Subjects'] as List<dynamic>)
              .map((subject) => subject['subject name'] as String)
              .toList();

          setState(() {
            _filteredSubjects = subjects;
            _selectedSubject = null; // Reset selected subject
          });
        } else {
          throw Exception('Failed to load subjects for selected major');
        }
      } catch (e) {
        print('Error fetching subjects: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load subjects. Please try again.')),
        );
      }
    } else {
      setState(() {
        _filteredSubjects = [];
        _selectedSubject = null;
      });
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
          SnackBar(content: Text('Form submitted successfully: ${responseData['message']}')),
        );
        setState(() {
          _selectedSubject = null;
          _selectedMajor = null;
        });
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form: ${responseData['message']}')),
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
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  hint: Text('Select Subject'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSubject = newValue;
                    });
                  },
                  items: _filteredSubjects.map((subject) {
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
