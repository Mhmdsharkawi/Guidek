import 'package:flutter/material.dart';
import 'package:guidek_project1/Annoncement_page/studyresources.dart';

import 'SubjectProposal.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects & Classes'),
        backgroundColor: Color(0xFF318c3c),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(Icons.lightbulb, 'Recommended Subjects', () {
              // Handle Books button press
            }),
            SizedBox(height: 20), // Space between buttons
            _buildIcon(Icons.assignment, 'Subject Proposal', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubjectProposal()),
              );
            }),
            SizedBox(height: 20), // Space between buttons
            _buildIcon(Icons.library_books, 'Books & Files', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudyResourcesScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    width: 73.5,
                    height: 73.5,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.267),
                      borderRadius: BorderRadius.circular(23.5),
                    ),
                  ),
                ),
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: Color(0xFF318c3c),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: Color(0xFFfdcd90), width: 3.4),
                  ),
                  child: Icon(icon, size: 40, color: Color(0xFFfdcd90)),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xff000000),
              fontWeight: FontWeight.normal,
              fontFamily: 'Acumin Variable Concept',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
