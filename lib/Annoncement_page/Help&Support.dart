import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HelpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  String? selectedDestination;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final Color primaryColor = Color(0xFF318C3C);
  final Color secondaryColor = Color(0xFFFDCD90);
  final Color grayColor = Colors.grey[600]!;

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }
  Future<void> _initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> sendSupportRequest() async {
    final String apiUrl = "https://guidekproject.onrender.com//users/support";
    final String? token = prefs?.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "issue": selectedDestination,
          "title": titleController.text,
          "description": descriptionController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('support ticket have been created successfully'))),
        );
      } else {
        // Failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('error_occurred'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('network_error'))),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('help_support'),
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('Issue'), style: TextStyle(fontFamily: 'Acumin Variable Concept', fontSize: 24, fontWeight: FontWeight.w600)),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDestination,
                          isExpanded: true,
                          hint: Text(
                            tr('select_page'),
                            style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              color: grayColor,
                              fontSize: 18,
                            ),
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: grayColor),
                          style: TextStyle(
                            fontFamily: 'Acumin Variable Concept',
                            color: grayColor,
                            fontSize: 18,
                          ),
                          items: [
                            tr('announcement_page'),
                            tr('subjects_classes_page'),
                            tr('chat_with_me_page'),
                            tr('procedure_guide_page'),
                            tr('gpa_calculator_page'),
                            tr('faq_page'),
                            tr('university_classes_page'),
                            tr('help_page'),
                            tr('profile_page'),
                            tr('others')
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDestination = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(tr('title'), style: TextStyle(fontFamily: 'Acumin Variable Concept', fontSize: 24, fontWeight: FontWeight.w600)),
                    SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: tr('enter_title'),
                        hintStyle: TextStyle(fontFamily: 'Acumin Variable Concept', color: Colors.white70, fontSize: 17),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      style: TextStyle(fontFamily: 'Acumin Variable Concept', color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 40),
                    Text(tr('description'), style: TextStyle(fontFamily: 'Acumin Variable Concept', fontSize: 24, fontWeight: FontWeight.w600)),
                    SizedBox(height: 12),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: descriptionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: tr('enter_description'),
                          hintStyle: TextStyle(fontFamily: 'Acumin Variable Concept', color: Colors.white70, fontSize: 17),
                          contentPadding: EdgeInsets.all(16),
                        ),
                        style: TextStyle(fontFamily: 'Acumin Variable Concept', color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          child: Text(
                            tr('clear'),
                            style: TextStyle(fontFamily: 'Acumin Variable Concept', fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            elevation: 3,
                          ),
                          onPressed: () {
                            setState(() {
                              titleController.clear();
                              descriptionController.clear();
                              selectedDestination = null;
                            });
                          },
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.send, size: 20, color: Colors.white),
                          label: Text(
                            tr('send_report'),
                            style: TextStyle(fontFamily: 'Acumin Variable Concept', fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            elevation: 3,
                          ),
                          onPressed: () {
                            sendSupportRequest();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
