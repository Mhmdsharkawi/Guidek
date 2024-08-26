import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProcedureDetailScreen extends StatefulWidget {
  final String procedurename;

  ProcedureDetailScreen({required this.procedurename});

  @override
  _ProcedureDetailScreenState createState() => _ProcedureDetailScreenState();
}

class _ProcedureDetailScreenState extends State<ProcedureDetailScreen> {
  late Future<List<Map<String, dynamic>>> stepsFuture;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    stepsFuture = fetchProcedureSteps(widget.procedurename);
  }

  Future<List<Map<String, dynamic>>> fetchProcedureSteps(String procedureName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('Access token is missing. Please log in again.');
      }

      final String url = 'https://guidekproject.onrender.com/transactions/transaction_steps/$procedureName';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['steps']);
      } else {
        throw Exception('Failed to load procedure steps');
      }
    } catch (e) {
      print('Error fetching procedure steps: $e');
      throw Exception('An error occurred while fetching procedure steps. Please try again.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        title: Text(
          widget.procedurename,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/last_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          FutureBuilder<List<Map<String, dynamic>>>(
            future: stepsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No steps available'));
              } else {
                final steps = snapshot.data!;
                final stepCount = steps.length;
                final progress = (currentStep + 1) / stepCount;

                return Stack(
                  children: [

                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          height: 20,
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            color: Color(0xFF318c3c),
                          ),
                        ),
                      ),
                    ),
                    // Centered Description
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            steps[currentStep]['description'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Acumin Variable Concept',
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Floating Action Buttons
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Visibility(
                          visible: currentStep > 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentStep--;
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [Color(0xFF318c3c), Color(0xFFa8e063)],
                                  center: Alignment(-0.3, -0.5),
                                  radius: 0.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.6),
                                    blurRadius: 10,
                                    offset: Offset(-2, -2),
                                    spreadRadius: 1,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_back, size: 32, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Visibility(
                          visible: currentStep < stepCount - 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentStep++;
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [Color(0xFF318c3c), Color(0xFFa8e063)],
                                  center: Alignment(-0.3, -0.5),
                                  radius: 0.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.6),
                                    blurRadius: 10,
                                    offset: Offset(-2, -2),
                                    spreadRadius: 1,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Icon(Icons.arrow_forward, size: 32, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
