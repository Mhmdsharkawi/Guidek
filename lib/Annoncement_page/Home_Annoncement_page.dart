import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guidek_project1/Annoncement_page/App_Info.dart';
import 'package:guidek_project1/Annoncement_page/Chat_With_Me.dart';
import 'package:guidek_project1/Annoncement_page/Contact_Us.dart';
import 'package:guidek_project1/Annoncement_page/File_Information.dart';
import 'package:guidek_project1/Signup&Login/home.dart';
import 'GPA_Calculator.dart';
import 'Chat_With_Me.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.english),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'EN';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.arabic),
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
          title: Text(AppLocalizations.of(context)!.logoutConfirmation),
          content: Text(AppLocalizations.of(context)!.logoutConfirmationMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text(AppLocalizations.of(context)!.yes, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        toolbarHeight: 70,
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
                title: Text(AppLocalizations.of(context)!.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.color_lens, color: Color(0xFF318c3c)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.theme),
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
                title: Text('${AppLocalizations.of(context)!.language}: $_selectedLanguage'),
                onTap: _changeLanguage,
              ),
              ListTile(
                leading: Icon(Icons.help, color: Color(0xFF318c3c)),
                title: Text(AppLocalizations.of(context)!.help),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.info, color: Color(0xFF318c3c)),
                title: Text(AppLocalizations.of(context)!.appInfo),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppInfoPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_mail, color: Color(0xFF318c3c)),
                title: Text(AppLocalizations.of(context)!.contactUs),
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
                  AppLocalizations.of(context)!.logout,
                  style: TextStyle(color: Colors.red),
                ),
                onTap: _confirmLogout,
              ),
              SizedBox(height: 292), // Space before the divider
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage()),
                    ).then((_) => _loadProfileImage());  // Reload image after returning from profile page
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
                            AppLocalizations.of(context)!.profileName,
                            style: TextStyle(
                              fontFamily: 'Acumin Variable Concept',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.manageAccount,
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
              _buildIcon(Icons.school, AppLocalizations.of(context)!.subjectsClasses, () {}),
              _buildIcon(Icons.chat_bubble, AppLocalizations.of(context)!.chatWithMe, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatWithMe()),
                );
              }),
              _buildIcon(Icons.description, AppLocalizations.of(context)!.procedureGuide, () {}),
              _buildIcon(Icons.calculate, AppLocalizations.of(context)!.gpaCalculator, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GpaCalculator()),
                );
              }),
              _buildIcon(Icons.help, AppLocalizations.of(context)!.faq, () {}),
              _buildIcon(Icons.location_on, AppLocalizations.of(context)!.universityClasses, () {}),
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
