import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:guidek_project1/Annoncement_page/App_Info.dart';
import 'package:guidek_project1/Annoncement_page/Chat_With_Me.dart';
import 'package:guidek_project1/Annoncement_page/Contact_Us.dart';
import 'package:guidek_project1/Annoncement_page/User_Information.dart';
import 'package:guidek_project1/Annoncement_page/classes_locations.dart';
import 'package:guidek_project1/Annoncement_page/Help&Support.dart';
import 'package:guidek_project1/Signup&Login/home.dart';
import 'GPA_Calculator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'q&a.dart';
import 'subjects.dart';
import 'package:http/http.dart' as http;

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
  String _userFullName = 'Loading...';
  ImageProvider _profileImage = AssetImage('assets/default_image.jpg');
  List<Map<String, dynamic>> announcements = [];
  bool _isLoading = true;
  String? _accessToken;
  List<String> imgList = [];


  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadAccessToken();
    _loadProfileImage();
    _loadUserName();
    _loadAnnouncements();
  }

  Future<void> _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = prefs.getString('accessToken') ?? '';
    });
  }

  Future<void> _loadAnnouncements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    final url = 'https://guidekproject.onrender.com/announcements/all_announcements';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['announcements'];

        setState(() {
          announcements = data.map<Map<String, String>>((item) {
            String imgUrl = item['img_url'] ?? 'default_image.jpg';
            return {
              'imgUrl': 'https://guidekproject.onrender.com/announcements/get_image/$imgUrl',
              'title': item['title'] ?? '',
              'content': item['content'] ?? '',
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        print('Failed to load announcements');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading announcements: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('userFullName');
    setState(() {
      _userFullName = fullName ?? 'Guest'; // Use 'Guest' if no name is found
    });
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? filename = prefs.getString('userImgUrl');
    String? accessToken = prefs.getString('accessToken');

    print('Filename: $filename');
    print('Access Token: $accessToken');

    // Determine the correct image URL based on whether the filename exists
    String imageUrl;
    if (filename != null && filename.isNotEmpty) {
      imageUrl = 'https://guidekproject.onrender.com/users/get_image/$filename';
    } else {
      imageUrl = 'https://guidekproject.onrender.com/users/get_image/default_image.jpg';
    }

    // Try loading the image with the Bearer token authorization header
    try {
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Check if the response is of type image
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.startsWith('image/')) {
          setState(() {
            _profileImage = MemoryImage(response.bodyBytes);
          });
          print('Profile image loaded successfully.');
        } else {
          print('Response is not an image, content-type: $contentType');
          setState(() {
            _profileImage = AssetImage('assets/default_image.jpg');
          });
        }
      } else {
        print('Failed to load profile image, status code: ${response.statusCode}');
        setState(() {
          _profileImage = AssetImage('assets/default_image.jpg');
        });
      }
    } catch (e) {
      print('Error loading profile image: $e');
      setState(() {
        _profileImage = AssetImage('assets/default_image.jpg');
      });
    }
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
              child: Text('cancel'.tr() , style: TextStyle(color: Color(0xFF318C3C)),),
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
                        Expanded(
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: _profileImage,
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userFullName,
                              style: TextStyle(
                                fontFamily: 'Acumin Variable Concept',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'manage_account'.tr(),
                              style: TextStyle(
                                fontFamily: 'Acumin Variable Concept',
                                fontSize: 14,
                                color: Color(0xFF318C3C),
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
                items: announcements.map((item) =>
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias, // Ensures the content respects the border radius.
                      child: Stack(
                        children: [
                          Image.network(
                            item['imgUrl']!, // The full image URL.
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity, // Ensure the image fills the container.
                            headers: {
                              'Authorization': 'Bearer $_accessToken', // Use the loaded access token.
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/default_image.jpg', fit: BoxFit.cover); // Fallback image in case of error.
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              color: Colors.black.withOpacity(0.6), // Dark overlay for better readability.
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5.0,
                                          color: Colors.black.withOpacity(0.7),
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    item['content']!,
                                    maxLines: 2, // Limit to 2 lines.
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis.
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5.0,
                                          color: Colors.black.withOpacity(0.7),
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ).toList(),
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
              )
              ,
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
                        _buildIcon(Icons.school, 'subjects_classes'.tr(), () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubjectsScreen()),
                        );
                        }),
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
                        _buildIcon(Icons.help, 'faq'.tr(), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QAScreen()),
                          );
                        }),
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
