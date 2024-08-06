import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:guidek_project1/Annoncement_page/App_Info.dart';
import 'package:guidek_project1/Annoncement_page/Chat_With_Me.dart';
import 'package:guidek_project1/Annoncement_page/Contact_Us.dart';
import 'package:guidek_project1/Annoncement_page/File_Information.dart';
import 'package:guidek_project1/Signup&Login/home.dart';
import 'GPA_Calculator.dart';
import 'package:guidek_project1/Annoncement_page/Subjects_and_Classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


class HomeAnnoncementPage extends StatefulWidget {
  const HomeAnnoncementPage({super.key});

  @override
  _HomeAnnoncementPageState createState() => _HomeAnnoncementPageState();
}

class _HomeAnnoncementPageState extends State<HomeAnnoncementPage> {
  int _current = 0;
  String _selectedLanguage = 'EN';
  bool _isDarkMode = false;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profileImagePath');
    });
  }


  final List<String> imgList = [
    'assets/NewGate.jpg',
    'assets/img.png',
  ];

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'EN';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('العربية'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'AR';
                  });
                  Navigator.of(context).pop();
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
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF318c3c),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: RichText(
            text: const TextSpan(
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
              icon: const Icon(Icons.menu),
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
              SizedBox(
                height: 100,
                child: Center(
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      RichText(
                        text: const TextSpan(
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
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.home, color: Color(0xFF318c3c)),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens, color: Color(0xFF318c3c)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Theme'),
                    Switch(
                      value: _isDarkMode,
                      onChanged: _toggleTheme,
                      activeColor: const Color(0xFF318c3c),
                    ),
                  ],
                ),
                onTap: () {
                  _toggleTheme(!_isDarkMode);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFF318c3c)),
                title: Text('Language: $_selectedLanguage'),
                onTap: _changeLanguage,
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Color(0xFF318c3c)),
                title: const Text('Help'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Color(0xFF318c3c)),
                title: const Text('App Info'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppInfoPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail, color: Color(0xFF318c3c)),
                title: const Text('Contact Us'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactUsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: _confirmLogout,
              ),
              const SizedBox(height: 292), // Space before the divider
              const Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfilePage()),
                    ).then((_) => _loadProfileImage());  // Reload image after returning from profile page
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: _profileImagePath != null
                            ? FileImage(File(_profileImagePath!))
                            : const AssetImage('assets/profile.jpg') as ImageProvider,
                        radius: 30,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Manage Account',
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
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
            items: imgList.map((item) => SizedBox(
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
            color: const Color(0xFFfdcd90),
          ),
          const SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1.0,
            children: [
              _buildIcon(Icons.school, 'Subjects & Classes', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubjectsAndClasses()),
                );
              }),
              _buildIcon(Icons.chat_bubble, 'Chat with me', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatWithMe()),
                );
              }),
              _buildIcon(Icons.description, 'Procedure Guide', () {}),
              _buildIcon(Icons.calculate, 'GPA Calculator', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GpaCalculator()),
                );
              }),
              _buildIcon(Icons.help, 'FAQ', () {}),
              _buildIcon(Icons.location_on, 'University Classes', () {}),
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
                    color: const Color(0xFF318c3c),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: const Color(0xFFfdcd90), width: 3.4),
                  ),
                  child: Icon(icon, size: 40, color: const Color(0xFFfdcd90)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
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
