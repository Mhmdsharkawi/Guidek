import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GpaCalculator extends StatefulWidget {
  @override
  _GpaCalculatorState createState() => _GpaCalculatorState();
}

class _GpaCalculatorState extends State<GpaCalculator> {
  final List<RowData> rows = [];
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();

  static const Color primaryColor = Color(0xFF318c3c);
  static const Color secondaryColor = Color(0xFFFDCD90);
  final Color grayColor = Colors.grey[600]!;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              'GPA Calculator',
              style: TextStyle(
                fontFamily: 'Acumin Variable Concept',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ],
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
              color: secondaryColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hours Passed:',
                                style: TextStyle(
                                  fontFamily: 'Acumin Variable Concept',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: grayColor,
                                ),
                              ),
                              TextField(
                                controller: hoursController,
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                  hintText: 'Enter hours passed',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Acumin Variable Concept',
                                  fontSize: 18,
                                  color: grayColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current GPA:',
                                style: TextStyle(
                                  fontFamily: 'Acumin Variable Concept',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: grayColor,
                                ),
                              ),
                              TextField(
                                controller: gpaController,
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                  hintText: 'Enter current GPA',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Acumin Variable Concept',
                                  fontSize: 18,
                                  color: grayColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          return _buildRow(index, index + 1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: _addRow,
              child: const Icon(Icons.add, color: Colors.black),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: _clearRows,
              child: const Icon(Icons.delete, color: Colors.black),
            ),
            FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: _calculateGPA,
              child: const Icon(Icons.calculate, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _addRow() {
    setState(() {
      rows.add(RowData());
    });
  }

  void _removeRow(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }

  void _clearRows() {
    setState(() {
      rows.clear();
    });
  }

  void _calculateGPA() {
    double totalPoints = 0;
    int totalHours = 0;

    // Create a map to track highest grade for each subject
    Map<String, RowData> subjectMap = {};

    // Process initial GPA
    int passedHours = int.tryParse(hoursController.text) ?? 0;
    double currentGPA = double.tryParse(gpaController.text) ?? 0.0;
    totalPoints = currentGPA * passedHours;
    totalHours = passedHours;

    // Process each row
    for (var row in rows) {
      double newGradePoints = _getPoints(row.grade);
      String subjectKey = 'subject_${row
          .hashCode}'; // Use a unique identifier for each subject

      if (row.isRetaken) {
        // If the subject is already in the map, subtract old points
        if (subjectMap.containsKey(subjectKey)) {
          double oldGradePoints = _getPoints(subjectMap[subjectKey]!.grade);
          totalPoints -= oldGradePoints * row.hours;
        }
        // Update the subject with the new grade
        subjectMap[subjectKey] = row;
        // Add the new grade points
        totalPoints += newGradePoints * row.hours;
      } else {
        // For non-retaken subjects, simply add the points
        totalPoints += newGradePoints * row.hours;
        // Add the subject to the map
        subjectMap[subjectKey] = row;
      }

      totalHours += row.hours;
    }

    // Calculate final GPA
    double gpa = totalHours > 0 ? totalPoints / totalHours : 0.0;
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            content: Text('Calculated GPA: ${gpa.toStringAsFixed(2)}'),
          ),
    );
  }

  double _getPoints(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.75;
      case 'B+':
        return 3.50;
      case 'B':
        return 3.00;
      case 'B-':
        return 2.75;
      case 'C+':
        return 2.50;
      case 'C':
        return 2.00;
      case 'C-':
        return 1.75;
      case 'D+':
        return 1.50;
      case 'D':
        return 1.0;
      case 'D-':
        return 0.75;
      case 'F':
        return 0.50;
      default:
        return 0.0;
    }
  }

  Widget _buildRow(int index, int subjectNumber) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.red, size: 16),
            onPressed: () => _removeRow(index),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          Text(
            'Subject $subjectNumber:',
            style: TextStyle(
              fontFamily: 'Acumin Variable Concept',
              fontSize: 14,
              color: grayColor,
            ),
          ),
          SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: rows[index].hours,
              items: [1, 2, 3].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  rows[index].hours = newValue!;
                });
              },
              icon: Icon(Icons.arrow_drop_down, color: primaryColor, size: 24),
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontFamily: 'Acumin Variable Concept',
              ),
              dropdownColor: Colors.white,
              isDense: false,
            ),
          ),




          SizedBox(width: 8),
          Text(
            'Grade:',
            style: TextStyle(
              fontFamily: 'Acumin Variable Concept',
              fontSize: 14,
              color: grayColor,
            ),
          ),
          SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: rows[index].grade,
              items: ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  rows[index].grade = newValue!;
                });
              },
              icon: Icon(Icons.arrow_drop_down, color: primaryColor, size: 24),
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontFamily: 'Acumin Variable Concept',
              ),
              dropdownColor: Colors.white,
              isDense: false,
            ),
          ),

          SizedBox(width: 8),
          Text(
            'Retaken:',
            style: TextStyle(
              fontFamily: 'Acumin Variable Concept',
              fontSize: 14,
              color: grayColor,
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: rows[index].isRetaken,
              onChanged: (newValue) {
                setState(() {
                  rows[index].isRetaken = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontFamily: 'Acumin Variable Concept',
            ),
          ),
          Icon(Icons.arrow_drop_down, color: primaryColor, size: 20),
        ],
      ),
    );
  }
}
class RowData {
  int hours = 1;
  String grade = 'A';
  bool isRetaken = false;
}
