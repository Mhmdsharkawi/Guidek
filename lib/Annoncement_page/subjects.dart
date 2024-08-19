import 'package:flutter/material.dart';
import 'package:guidek_project1/Annoncement_page/studyresources.dart';
import 'SubjectProposal.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF318C3C);
    final Color secondaryColor = Color(0xFFFDCD90);
    final Color grayColor = Colors.grey[600]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subjects & Classes',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIcon(Icons.lightbulb, 'Recommended Subjects', () {
                      // Handle Recommended Subjects button press
                    }),
                    SizedBox(height: 20),
                    _buildIcon(Icons.assignment, 'Subject Proposal', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectProposal(),
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                    _buildIcon(Icons.library_books, 'Books & Files', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudyResourcesScreen(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
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
                    color: Color(0xFF318C3C),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: Color(0xFFFDCD90), width: 3.4),
                  ),
                  child: Icon(icon, size: 40, color: Color(0xFFFDCD90)),
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
