import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String response = await rootBundle.loadString('assets/majors_subjects.json');
    final Map<String, dynamic> data = json.decode(response);

    setState(() {
      _data = data;
      _majors = data.keys.toList();
      _filteredSubjects = []; // Initially empty
    });
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
      _filteredSubjects = []; // Reset to empty
    }
  }

  void _submitForm() {
    final fullName = _fullNameController.text;
    final studentNumber = _studentNumberController.text;

    if (fullName.isEmpty || studentNumber.isEmpty || _selectedSubject == null || _selectedMajor == null) {
      // Handle validation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a major and subject')),
      );
      return;
    }

    // Handle form submission
    print('Full Name: $fullName');
    print('Student Number: $studentNumber');
    print('Selected Major: $_selectedMajor');
    print('Selected Subject: $_selectedSubject');

    // Clear the form
    _fullNameController.clear();
    _studentNumberController.clear();
    setState(() {
      _selectedSubject = null;
      _selectedMajor = null;
    });
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
            constraints: BoxConstraints(maxWidth: 600), // Adjust maxWidth as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: _appBarColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                  ),
                  cursorColor: _appBarColor,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _studentNumberController,
                  decoration: InputDecoration(
                    labelText: 'Student Number',
                    labelStyle: TextStyle(color: _appBarColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _appBarColor),
                    ),
                  ),
                  cursorColor: _appBarColor,
                ),
                SizedBox(height: 16),
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
                      child: Text(subject),
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
