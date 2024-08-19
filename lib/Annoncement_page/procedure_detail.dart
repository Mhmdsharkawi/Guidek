import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<List<Map<String, dynamic>>> fetchProcedureSteps(String procedurename) async {
    final String url = 'https://guidekproject.onrender.com/transactions/transaction_steps/$procedurename';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['steps']);
    } else {
      throw Exception('Failed to load procedure steps');
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
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                // Positioned Progress Bar at the Top
                Positioned(
                  top: 40, // Move the progress bar down
                  left: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Carved edges
                    child: Container(
                      width: double.infinity,
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color: Color(0xFF318c3c),
                        minHeight: 10, // Increase the height
                      ),
                    ),
                  ),
                ),
                // Centered Description
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      steps[currentStep]['description'],
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
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
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFF318c3c),
                        onPressed: () {
                          setState(() {
                            currentStep--;
                          });
                        },
                        child: Icon(Icons.arrow_back),
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
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFF318c3c),
                        onPressed: () {
                          setState(() {
                            currentStep++;
                          });
                        },
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
