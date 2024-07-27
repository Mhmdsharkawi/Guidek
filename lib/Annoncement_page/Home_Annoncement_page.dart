import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Settings_page.dart';
import 'GPA_Calculator.dart'; // Make sure to import the GpaCalculator page

class HomeAnnoncementPage extends StatefulWidget {
  @override
  _HomeAnnoncementPageState createState() => _HomeAnnoncementPageState();
}

class _HomeAnnoncementPageState extends State<HomeAnnoncementPage> {
  int _current = 0;

  final List<String> imgList = [
    'assets/NewGate.jpg',
    'assets/img.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'GUIDE',
                  style: TextStyle(
                    fontFamily: 'Acumin Variable Concept',
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    letterSpacing: 12.0,
                  ),
                ),
                WidgetSpan(
                  child: SizedBox(width: 0),
                ),
                TextSpan(
                  text: 'K',
                  style: TextStyle(
                    fontFamily: 'Acumin Variable Concept',
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CarouselSlider(
            items: imgList.map((item) => Container(
              width: double.infinity,
              child: Image.asset(
                item,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )).toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.4,
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 12.0,
            color: Color(0xFFfdcd90),
          ),
          SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1.0,
            children: [
              _buildIcon(Icons.school, 'Subjects & Classes', () {}),
              _buildIcon(Icons.chat_bubble, 'Chat with me', () {}),
              _buildIcon(Icons.description, 'Procedure Guide', () {}),
              _buildIcon(Icons.calculate, 'GPA Calculator', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GpaCalculator()),
                );
              }),
              _buildIcon(Icons.help, 'FAQ', () {}),
              _buildIcon(Icons.contact_mail, 'Contact Us', () {}),
            ],
          ),
        ],
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
