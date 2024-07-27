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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Status bar color
      statusBarIconBrightness: Brightness.light, // Status bar icon color
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              'GPA Calculator',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.normal),
            ),
          ],
        ),

      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/guidek-bg.jpg.svg',
              fit: BoxFit.fill,
              color: Color.fromARGB(100, 220, 220, 220),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                          Text('Hours Passed :'),
                          TextField(
                            controller: hoursController,
                            decoration: InputDecoration(
                              hintText: 'Enter hours passed',
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
                          Text('Current GPA :'),
                          TextField(
                            controller: gpaController,
                            decoration: InputDecoration(
                              hintText: 'Enter current GPA',
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
              backgroundColor: Color(0xFF318c3c),
              onPressed: _addRow,
              child: Icon(Icons.add,color: Colors.black,),
            ),
            FloatingActionButton(
              backgroundColor: Color(0xFF318c3c),
              onPressed: _calculateGPA,
              child: Icon(Icons.calculate,color: Colors.black,),
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

  void _calculateGPA() {
    double totalPoints = 0;
    int totalHours = 0;
    int passedHours = int.tryParse(hoursController.text) ?? 0;
    double currentGPA = double.tryParse(gpaController.text) ?? 0.0;

    // Calculate current total points
    totalPoints = currentGPA * passedHours;
    totalHours = passedHours;

    // Add points and hours from new subjects
    for (var row in rows) {
      totalPoints += _getPoints(row.grade) * row.hours;
      totalHours += row.hours;
    }

    double gpa = totalPoints / totalHours;
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
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.clear, color: Colors.red),
            onPressed: () => _removeRow(index),
          ),
          Text("Subject $subjectNumber"),
          SizedBox(width: 8),
          DropdownButton<int>(
            value: rows[index].hours,
            items: [1, 2, 3].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value hours'),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                rows[index].hours = newValue!;
              });
            },
          ),
          SizedBox(width: 16),
          DropdownButton<String>(
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
        ],
      ),
    );
  }
}

class RowData {
  int hours;
  String grade;

  RowData({this.hours = 1, this.grade = 'A'});
}