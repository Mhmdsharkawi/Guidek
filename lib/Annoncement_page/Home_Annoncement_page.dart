import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:guidek_project1/Annoncement_page/App_Info.dart';
import 'package:guidek_project1/Annoncement_page/Chat_With_Me.dart';
import 'package:guidek_project1/Annoncement_page/Contact_Us.dart';
import 'package:guidek_project1/Annoncement_page/File_Information.dart';
import 'package:guidek_project1/Annoncement_page/classes_locations.dart';
import 'package:guidek_project1/Annoncement_page/Help&Support.dart';
import 'package:guidek_project1/Signup&Login/home.dart';
import 'GPA_Calculator.dart';
import 'Chat_With_Me.dart';
import 'classes_locations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

class HomeAnnoncementPage extends StatefulWidget {
  const HomeAnnoncementPage({super.key});

  @override
  _HomeAnnoncementPageState createState() => _HomeAnnoncementPageState();
}

class _HomeAnnoncementPageState extends State<HomeAnnoncementPage> {
  bool _isLoggedIn = true;
  int _current = 0;
  String _selectedLanguage = 'EN';
  bool _isDarkMode = false;
  String? _profileImagePath;

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  
    _loadProfileImage();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? true;
    });
    if (!_isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()), 
      );
    }
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
          title: Text('select_language'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'EN';
                  });
                  context.setLocale(Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('العربية'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'AR';
                  });
                  context.setLocale(Locale('ar'));
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
          title: Text('logout_confirmation'.tr()),
          content: Text('logout_message'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()), 
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                icon: Icon(Icons.menu),
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
            child: Column(
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
                  title: Text('home'.tr()),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Color(0xFF318c3c)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('theme'.tr()),
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
                  title: Text('language'.tr() + ': $_selectedLanguage'),
                  onTap: _changeLanguage,
                ),
                ListTile(
                  leading: Icon(Icons.help, color: Color(0xFF318c3c)),
                  title: Text('help_support'.tr()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HelpSupportPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Color(0xFF318c3c)),
                  title: Text('app_info'.tr()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppInfoPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_mail, color: Color(0xFF318c3c)),
                  title: Text('contact_us'.tr()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'logout'.tr(),
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: _confirmLogout,
                ),
                Spacer(),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfilePage()),
                      ).then((_) => _loadProfileImage());
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: _profileImagePath != null
                              ? FileImage(File(_profileImagePath!))
                              : AssetImage('assets/profile.jpg') as ImageProvider,
                          radius: 30,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zaid Nsour',
                              style: TextStyle(
                                fontFamily: 'Acumin Variable Concept',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'manage_account'.tr(),
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
        body: SafeArea(
          child: Column(
            children: [
              CarouselSlider(
                items: imgList.map((item) =>
                    Container(
                      width: double.infinity,
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )).toList(),
                options: CarouselOptions(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.0,
                      children: [
                        _buildIcon(Icons.school, 'subjects_classes'.tr(), () {}),
                        _buildIcon(Icons.chat_bubble, 'chat_with_me'.tr(), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatWithMe()),
                          );
                        }),
                        _buildIcon(Icons.description, 'procedure_guide'.tr(), () {}),
                        _buildIcon(Icons.calculate, 'gpa_calculator'.tr(), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GpaCalculator()),
                          );
                        }),
                        _buildIcon(Icons.help, 'faq'.tr(), () {}),
                        _buildIcon(
                            Icons.location_on, 'university_classes'.tr(), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClassesLocationsScreen()),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
