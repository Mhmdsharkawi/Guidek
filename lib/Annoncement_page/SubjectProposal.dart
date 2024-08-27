import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubjectProposal extends StatefulWidget {
  @override
  _SubjectProposalState createState() => _SubjectProposalState();
}

class _SubjectProposalState extends State<SubjectProposal> {
  List<String> _majors = [];
  List<String> _filteredSubjects = [];
  String? _selectedSubject;
  String? _selectedMajor;
  String? _selectedDay;

  final Color _primaryColor = Color(0xFF318C3C);
  final Color _secondaryColor = Color(0xFFFDCD90);
  final Color _grayColor = Colors.grey[600]!;

  @override
  void initState() {
    super.initState();
    _loadMajorsAndSubjects();
  }

  Future<void> _loadMajorsAndSubjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('Access token is missing. Please log in again.');
      }

      final majorsResponse = await http.get(
        Uri.parse('https://guidekproject.onrender.com/majors/all_majors'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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
        throw Exception('Failed to load majors'.tr());
      }
    } catch (e) {
      print('Error fetching majors: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load majors. Please try again.')),
      );
    }
  }


  void _updateSubjects(String? major) async {
    if (major != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken');

        if (token == null) {
          throw Exception('No JWT token found');
        }

        final response = await http.get(
          Uri.parse('https://guidekproject.onrender.com/majors/get_subjects/$major'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          final List<String> subjects = (data['Subjects'] as List<dynamic>)
              .map((subject) => subject['subject name'] as String)
              .toList();

          setState(() {
            _filteredSubjects = subjects;
            _selectedSubject = null;
          });
        } else {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final String errorMessage = errorData['message'] ?? 'Failed to load subjects for selected major';
          throw Exception(errorMessage);
        }
      } catch (e) {
        print('Error fetching subjects: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load subjects. Please try again.')),
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
    if (_selectedSubject == null || _selectedMajor == null || _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a major, subject, and days')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    final data = {
      'subject_name': _selectedSubject,
      'suggested_days': _selectedDay,
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
          _selectedDay = null;
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
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'subject_proposal'.tr(),
          style:const TextStyle(
            fontFamily: 'Acumin Variable Concept',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _primaryColor,
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
              color: _secondaryColor,  
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        DropdownButtonFormField<String>(
                          value: _selectedMajor,
                          hint: Text('select_major').tr(),
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
                            labelText: 'major'.tr(),
                            labelStyle: TextStyle(color: _primaryColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedSubject,
                          hint: Text('select_subject').tr(),
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
                            labelText: 'subject'.tr(),
                            labelStyle: TextStyle(color: _primaryColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedDay,
                          hint:const Text('select_day').tr(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDay = newValue;
                            });
                          },
                          items:const [
                            DropdownMenuItem<String>(
                              value: "Monday Wednesday",
                              child: Text("ن ر"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Sunday Tuesday Thursday",
                              child: Text("ا ث خ"),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'day'.tr(),
                            labelStyle: TextStyle(color: _primaryColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('submit').tr(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
