import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GpaCalculator extends StatefulWidget {
  @override
  _GpaCalculatorState createState() => _GpaCalculatorState();
}

class _GpaCalculatorState extends State<GpaCalculator> {
  final List<RowData> rows = [];
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();

  static const Color appBarColor = Color(0xFF318c3c);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'GPA Calculator',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Background2.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hours Passed:'),
                          TextField(
                            controller: hoursController,
                            cursorColor: appBarColor,
                            decoration: InputDecoration(
                              hintText: 'Enter hours passed',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: appBarColor),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: appBarColor),
                              ),
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
                          const Text('Current GPA:'),
                          TextField(
                            cursorColor: appBarColor,
                            controller: gpaController,
                            decoration: InputDecoration(
                              hintText: 'Enter current GPA',
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: appBarColor),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: appBarColor),
                              ),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              backgroundColor: appBarColor,
              onPressed: _addRow,
              child: const Icon(Icons.add, color: Colors.black),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: _clearRows,
              child: const Icon(Icons.delete, color: Colors.black),
            ),
            FloatingActionButton(
              backgroundColor: appBarColor,
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
      String subjectKey = 'subject_${row.hashCode}'; // Use a unique identifier for each subject

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
      builder: (context) => AlertDialog(
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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.red),
            onPressed: () => _removeRow(index),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Subject $subjectNumber hours: '),
                    Expanded(
                      child: DropdownButton<int>(
                        value: rows[index].hours,
                        items: [1, 2, 3].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            rows[index].hours = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButton<String>(
                        value: rows[index].grade,
                        items: ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            rows[index].grade = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (rows[index].isRetaken)
                  Center(
                    child: Row(
                      children: [
                        const Text('Old'),
                        const SizedBox(width: 15), // Adjust to align with other rows
                        Expanded(
                          child: DropdownButton<String>(
                            value: rows[index].oldGrade,
                            items: ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                rows[index].oldGrade = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 150),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: rows[index].isRetaken,
                onChanged: (newValue) {
                  setState(() {
                    rows[index].isRetaken = newValue!;
                  });
                },
                activeColor: appBarColor, // Matching the app bar color
              ),
              const Text('Retaken'),
            ],
          ),
        ],
      ),
    );
  }
}

class RowData {
  int hours;
  String grade;
  bool isRetaken;
  String oldGrade;

  RowData({
    this.hours = 1,
    this.grade = 'A',
    this.isRetaken = false,
    this.oldGrade = 'A',
  });
}
