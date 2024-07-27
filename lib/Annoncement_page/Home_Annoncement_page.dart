import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'GPA_Calculator.dart';

class HomeAnnoncementPage extends StatefulWidget {
  @override
  _HomeAnnoncementPageState createState() => _HomeAnnoncementPageState();
}

class _HomeAnnoncementPageState extends State<HomeAnnoncementPage> {
  int _current = 0;
  String _selectedLanguage = 'EN'; // Default language
  bool _isDarkMode = false; // Default theme mode

  final List<String> imgList = [
    'assets/NewGate.jpg',
    'assets/img.png',
  ];

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'EN';
                  });
                  Navigator.of(context).pop();
                  // تنفيذ تغيير اللغة إلى الإنجليزية
                },
              ),
              ListTile(
                title: Text('العربية'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'AR';
                  });
                  Navigator.of(context).pop();
                  // تنفيذ تغيير اللغة إلى العربية
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    // قم بتحديث موضوع التطبيق هنا بناءً على قيمة _isDarkMode
  }

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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'GUIDE',
                              style: TextStyle(
                                fontFamily: 'Acumin Variable Concept',
                                fontSize: 32,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF318c3c),
                                letterSpacing: 12.0,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: 3),
                            ),
                            TextSpan(
                              text: 'K',
                              style: TextStyle(
                                fontFamily: 'Acumin Variable Concept',
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF318c3c),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              ListTile(
                leading: Icon(Icons.home, color: Color(0xFF318c3c)),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.color_lens, color: Color(0xFF318c3c)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Theme'),
                    Switch(
                      value: _isDarkMode,
                      onChanged: _toggleTheme,
                      activeColor: Color(0xFF318c3c),
                    ),
                  ],
                ),
                onTap: () {
                  _toggleTheme(!_isDarkMode);
                },
              ),
              ListTile(
                leading: Icon(Icons.language, color: Color(0xFF318c3c)),
                title: Text('Language: $_selectedLanguage'),
                onTap: _changeLanguage,
              ),
              ListTile(
                leading: Icon(Icons.help, color: Color(0xFF318c3c)),
                title: Text('Help'),
                onTap: () {
                  // الانتقال إلى صفحة المساعدة
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Color(0xFF318c3c)),
                title: Text('App Info'),
                onTap: () {
                  // عرض معلومات التطبيق
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_mail, color: Color(0xFF318c3c)),
                title: Text('Contact Us'),
                onTap: () {
                  // الانتقال إلى صفحة الاتصال
                },
              ),
              SizedBox(height: 348), // Space before the divider
              Divider(color: Colors.grey), // Thin line divider
              // Profile information
              Padding(
                padding: const EdgeInsets.fromLTRB(8,0,0,0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual path
                      radius: 30,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name', // Replace with actual name
                          style: TextStyle(
                            fontFamily: 'Acumin Variable Concept',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Manage Account', // Replace with actual status
                          style: TextStyle(
                            fontFamily: 'Acumin Variable Concept',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              _buildIcon(Icons.location_on, 'University class', () {}),
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
